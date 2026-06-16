Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC06CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5455F6B0096; Tue, 16 Jun 2026 17:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CBD6B009B; Tue, 16 Jun 2026 17:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4590C6B009D; Tue, 16 Jun 2026 17:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 144606B0096
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:02:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1216840111
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:57:31 +0000 (UTC)
X-FDA: 84885928302.17.2F078EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5257410000A
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:57:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o2PnEnYx;
	spf=pass (imf14.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781618249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2HQDPl4Fge9D8LBQD7QCKGIXM2QN58OYRKHRC0rBkGU=;
	b=gPlWui4WZvBbm/wpFswKrt4YgCMQPTOvQtOJV7KVw1awN0PHAq5MnO8qKNu9ncWgUhHWAC
	AaR8babkLrhEX8TrAonQvUZVvDwj4t9ZbzVurAFchGzqYXiHlpJYDDWlCEOfgFUu7qaIfr
	fc8QIErS1C8OiCOCnqVz2ltg8csmpI8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o2PnEnYx;
	spf=pass (imf14.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781618249;
	b=CuU3vbjr/Ev2tWeTU3SZYSYy8ranMFcb+sEfE/koPCosOMYbxKV0gS9Zf6tTWMkLoA+Tdi
	mdQzUdEutoPBv3pmg9cYdaUqatG9SJti7pIg9BBUdTjdjDQuivugCn8tklHLy6RCPevliC
	vSLwNq4/oI6XbruYQgxEG2OXszqM8KE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DCEC6600AB;
	Tue, 16 Jun 2026 13:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D6F1F000E9;
	Tue, 16 Jun 2026 13:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618246;
	bh=2HQDPl4Fge9D8LBQD7QCKGIXM2QN58OYRKHRC0rBkGU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=o2PnEnYxJOrqBmCTljOBgmtEqnsmtt4iSTaJauqZ6cxnQ+mR+iXvcyycJR1kFvcCe
	 yWUyoeAwVH4s8tQiUkJCdHppm3BEkHIAYGBXKDK+Hc4qWA8olKjWoGLXQxnq4PcQtW
	 rP6FZaoqCE/Fi8EeG9QlgoFJndtCWvd1CfTRCL2Kumkaxi6ZhYDy7upSrUZCpbFs1c
	 WWmBs/k495pgDYgSPRlL82RAGWDEmEWKxobGoZqVROdWYlhx3mv61s4bx/kkuzdaKF
	 sCbqTj2qfBjiaxGGrTPVZIBdv0jG4izkN/6lviMsMkM52YxSA7t+LjS6/DxzGY16yX
	 EG2wVnsWfHqFA==
Message-ID: <bdfdbd6b-81e0-49e3-a02f-2dc75727a71b@kernel.org>
Date: Tue, 16 Jun 2026 15:57:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
 ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>,
 dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de,
 brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 pankaj.raghav@linux.dev, Daniel Gomez <da.gomez@samsung.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d5d99db2-9d34-4caf-bcc8-c4a3af561901@kernel.org>
 <agQPtTx2EXHr10Nn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <ah24DlQobLjjDTGt@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Daniel Gomez <da.gomez@kernel.org>
In-Reply-To: <ah24DlQobLjjDTGt@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5257410000A
X-Stat-Signature: tnzckufssc9mxm1k9gncaqpwmqhjincf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781618249-853379
X-HE-Meta: U2FsdGVkX1+yz4zmMRekO8OYHdshfwvvK996WgafHHsf6hc7ICdYM8LFjKNiOdM4OqoxY3LNk5pPqzH8aSv1fkFlaYNnG316j9ctgoFFvU7Q2QTnLJKY6mRMFBBaM8R1kahSKIYCLMN1NQ7Q4PoRAb+V3sTXXWzY2wLLAPD5/jifBvb0QMraJqnb8R+X8qg4tGaT/QSyNlGiToAU4/BBcTWjlnxElmBlP/8t9Q9yiV+ihb/YlyOWwFS1JbGIkfPiwED9YjoqL7652gOuf7+pDIfJZTyAaHKKJ/HlNRFLA5H/TDK57g2WnfbSA0dji9QP0ffgUKyMxq59jKrF05GnmxvmaKXFM9h7lDJIbzAsFbAuVKULasR9YNlAHn5uDEmfIl3nJ+OZQXsKhD3N3SBQrniQ2+TzxHY5avPCk0pn8qLcfXlQ411yh4ymYlB9DspYAmyELZEQkpgqEs4fHr7oFrZxth9+I9frPQQIY5dBtsbS38YWoRRUCBT6AzvV6tXckFVfJ9VWjPVHd9qYWEaJxsY+XNUwpBfc0w122nalu9BqT6XV4BdkGhk57q8YLMmClTpNdBU6myPsfNA7n/cy6uZMEEtP4LL8hwzjnXqfLGtD2nl7JExsXIXe79Ic+91Y7IYiCd+uIup0iyOHzd7HEZLiTK9nkFii9PZG75zDaHASRQ+J+w2ALRgcp6NOEOgdFaX7qUscuLHfhtfl/YDhPZvr9oTurA673H8LArnRVwin0UUoVDoTP00iPjV9LC1abt1B4m1d3/Il7IIw08+AR4cHROuFFWgd4hGIoLKpisxmps/nZALs/FhCrRk0opwFuLZd9pG/0HwKtMLOVQS0hUAL6iXp7ZIqFpEGc0BYBzoU7SWaSQLvo49q4fDLbQV/h+8wTBFnUYcF1X8l6FY+kgli/SURF1X5UuZMDMv+2y3wvpssW9gqFS4ewL+NwPP98rqdp13UzcQxHnqKKvE
 t1QQDFRj
 HgsU0fsnrPbOzIP3+F1comZiogXArn4bLK319jm3r6nYQkfnMSg1h5NyyVhUq+un89zE/4xWtmogJ8/2L+YwNmD/HWPeblqRlPQcCT25Ie0EkD7HPpKX+07gYHb/82YepbwRQKe2l51o1blpe/x2fcvhdz5sgPsbbiLm6b0rjevdsV8h+bOtFGX4HSi9wkGU+eUVk9oJpoh3RgA/DA/EGXF0+WfETr4X5jpWOydferJFholNQsPZPOy7x1b6pHgRVyO9wdWlr9Wm5ArqIIcmWC6zIPfreKWvpjEjGVy5Y80cdl3R2wB52d/ef2yODs43hJWZiBGkONnQU2JM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/06/2026 18.49, Ojaswin Mujoo wrote:
> On Wed, May 13, 2026 at 11:14:21AM +0530, Ojaswin Mujoo wrote:
>> On Mon, May 04, 2026 at 09:54:49AM +0200, Daniel Gomez wrote:
>>> On 08/04/2026 20.45, Ojaswin Mujoo wrote:
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 720bca83..1c76634b 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -2077,16 +2077,34 @@ test_dontcache_io(void)
>         return 1;
>  }
> 
> +/*
> + * Use a temporary file to test RWF_WRITETHROUGH so as to not modify the
> + * original. This is so that fsx expected contents and the actual contents
> + * of the original file don't go out of sync
> + */
>  int
>  test_writethrough_io(void)
>  {
>         char buf[4096];
> +       char tmpname[PATH_MAX];
> +       int tmp_fd;
>         struct iovec iov = { .iov_base = buf, .iov_len = sizeof(buf) };
>         int ret, e;
> 
> +       snprintf(tmpname, sizeof(tmpname), "%s.fsx.XXXXXX", fname);
> +
> +       tmp_fd = mkstemp(tmpname);
> +       if (fd < 0) {
> +               perror("test_writethrough_io: mkstemp() failed\n");
> +               exit(132);
> +       }
> +
>         memset(buf, '\0', sizeof(buf));
> -       ret = pwritev2(fd, &iov, 1, 0, RWF_WRITETHROUGH);
> +       ret = pwritev2(tmp_fd, &iov, 1, 0, RWF_WRITETHROUGH);
>         e = ret < 0 ? errno : 0;
> +
> +       close(tmp_fd);
> +
>         if (e == EOPNOTSUPP) {
>                 if (!quiet)
>                         fprintf(stderr,
> 


I think this is missing:

@@ -2158,12 +2175,6 @@ test_writethrough_io(void)
                return 0;
        }

-       if (ftruncate(fd, file_size) != 0) {
-               perror("test_writethrough_io: failed to ftruncate to 0\n");
-               exit(132);
-       }
-
-

The fix works for me after a stress loop test on generic/457.

> 
> Im unable to replicate the 415 failure, but this one is strange because it
> doesn't involve any writethrough IO. In you previous runs have you seen
> this be flaky?

I couldn't confirm back then, so I think we can ignore it. Also, unrelated.

> 
> Admittedly, I've not yet started thorough testing since this is in early
> RFC and the design is still getting finalized but I appriciate the help
> in testing this.


No problem. IMHO, testing makes a design more robust, once the path is
agreed on. That said, do you think the path needs changing? Reading LWN
and the patch series threads, I don't see any blocker. You can cc me for
the next iteration and I'll follow up with more testing.

