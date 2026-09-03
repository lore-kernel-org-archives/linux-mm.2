Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32DACC624D7
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326246B00B4; Thu,  3 Sep 2026 06:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D66C6B00B5; Thu,  3 Sep 2026 06:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2147D6B00B6; Thu,  3 Sep 2026 06:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06D896B00B4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:15:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 906FC8047E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:15:45 +0000 (UTC)
X-FDA: 85172044650.15.E262FB9
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf16.hostedemail.com (Postfix) with ESMTP id A223A180002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:15:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sPJYGYnG;
	spf=pass (imf16.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788430544;
	b=VDxN+yZB+LXaZCN7octXjBvnFZHSpsFZHWk16PZ8AHr1YOnvM/MV+hzBNDzXtFEjNZW/ln
	/LeFOzpqgYleSL32nu+c8q8tcvde0hONv0a6SoCMWZollHE7z3ZPlA1J3QgzPHx2GF2159
	Hmiuqm3a/si0hRYjeW/31PdykPThnSc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sPJYGYnG;
	spf=pass (imf16.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788430544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OyJ6y9tOxjQFUNrQBycZ3KwqBU7c38czB5+Luukp45Q=;
	b=patwjyqiJSipoLcsH2//BHRfzZ1bi52aEbR+sC+bK2fdTEtC2tO3EWhpJhlHWH3LMH8K3u
	e7yqwkh04JMGUBJsJore80BQQYJ0hX2z/YJi3dGehpWSW0wDm++iFOhJDBQ0SZzinEU7aN
	HOCFAHCtOby12Ce6EEhdCdVn+qlaiK8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788430540; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=OyJ6y9tOxjQFUNrQBycZ3KwqBU7c38czB5+Luukp45Q=;
	b=sPJYGYnG2txk19WRr+QhFf9NRCGG1p1D3k/+nnBE6DnVZmhe2bT3CSBy1My8mA992KkTpxpMeQlY75oxB4i1L7c16mxirzxZFqnKkrI/cz2IM2eZA7BScMc88TsFSALewyxEgTxLsoA8r5krN2gCyMgBU/h1uNMzq47NFEjeWQs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XAFjWt3_1788430538;
Received: from 30.134.112.244(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAFjWt3_1788430538 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 18:15:39 +0800
Message-ID: <0dfb2aff-47a7-42bc-8698-da7d9f89663c@linux.alibaba.com>
Date: Thu, 3 Sep 2026 18:15:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ocfs2: Refuse to enable ocfs2 format for another
 filesystem
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, ocfs2-devel@lists.linux.dev,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Farhad Alemi <farhad.alemi@berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260903090053.13120-1-jack@suse.cz>
 <20260903090508.1360863-3-jack@suse.cz>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260903090508.1360863-3-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A223A180002
X-Stat-Signature: 1j8neacxstbruenyfywrsyxshmkbdpru
X-HE-Tag: 1788430542-215342
X-HE-Meta: U2FsdGVkX19rcZUkX5nhJ6nsSC+2Lh4Ipi2E+ZvVP62OWpscRkUXbKtnlTOEsUNLo0SBH+QglzzY2/5OXmrqYdRbZ3KHQp9txmpZm4lNc+ryBQFaoy5mh+C2yaONF2nhQF8SiLDGbkoKlQgouN5y/CONvkL54LIo1C5pc9qrGwqmPDwBxv273/6Tb0jM3WSLoy6afZozuHh6YOtCGn3dJNW5zc0uOMhZuMn8Eec3hT6up8GJxYRPzmsBwFgP+mIibYnon4g2BznJwP810v8s0M8AJMO8ofquzglk2a3EdGv8AZ8wEBasYq1GV//IoTZD7GDjTl07XODV439qfXR4Qg9EUDH49a9qbscEYogCxqM24md55gHnuL7zzb8cP8Y9mGNmzEX6w/7s6uOvDHkU4jVHS/vQWTji6eGX/Dpnk1ab4uJHqSpdxeY8I6XJqDwZ8GvxqPsxxN3xNQrM3a1vpn53fPhGFdejO8BHA7Uy5X6FjLDk9iDegUBJ0R3OnRLcuKx+jgwB/i4Y0xHE9lH7OwjHH9oy/KP1ivtKzpAqFRv3d8qoVtiuIjdGA6KtjUhCuSS+zj20xYYD/x3aFG/Fad32Hi8qns/Glm9ZPmEMpKz7p71yLtLl87SJUivwJncWsDiWePzY2uhX8i7uq/7WTzwMehNqVyrOODh4wp2GDwLnFZ4NuBXuOMAzMhOONxCHLQI42y54ErtTYrtjaDpZ2njyhfjqbGsJA6g2PSZxWrHZ5uAm5Vv0zF9H8fdo61Ua3U9pm+5jqYzIH4Tg739VC8YZoWVA8/a0jufTca5ZmvaL+2CUzDD1G5X5EEd0zonnf6CkFoDCFN1lIztDMIRqDJ2mokRYbsBQOHvvKtOFOEfBQ7SQxiQYU/N9Gufd6YQLs55263ia5TM7XRhDIvb53kyUBvAoGG3pNOZ0l7biqtKsn2jyWUdKsz3EN03YGFCqaqzD7XNfFaWC7dZKFec
 hrm0whbF
 R+K1qv4dD63AS4uwpAcOjdLxU0liGfB+nAxvv5RYdx1r1xe8F0Lf+foJzZRV+2SL5qukzREJ96sURv8i1X4h/IRrLL855FGXd1NfIRueq9wZcCBR2+4gXYIES8EBVUYLIBMHuXZYzaw8DdhTZIaH3w6InPeWbgE6Z19NWkZcT/1suLz9E7r3r5WyzOkmAe6dt2QOqmxys8rc2dc5KnRUFxkdzWrdkhn+jd5N9/1uecU+4odC8iNonxdMYOT7sCD9eSZgn1qTfZL6dAtBbGxw/eHwp8mPU5QHosmY73I3us4TDUEM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/3/26 5:05 PM, Jan Kara wrote:
> It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
> requesting to enable quota using ocfs2 quota format. With suitable
> passed arguments this can get upto ocfs2_local_check_quota_file() where
> the passed superblock is from the ext4 filesystem and that can cause all
> sorts of interesting things, most likely crashes. As ocfs2 quotas are
> specific to ocfs2 filesystem, verify we are indeed enabling quotas
> there.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/quota_local.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index f55810c59b1b..a2b276bcd0a8 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -171,6 +171,10 @@ static int ocfs2_local_check_quota_file(struct super_block *sb, int type)
>  	struct ocfs2_disk_dqheader *dqhead;
>  	int status, ret = 0;
>  
> +	/* OCFS2 quota format is supported only for OCFS2 filesystems */
> +	if (sb->s_magic != OCFS2_SUPER_MAGIC)
> +		goto out_err;
> +
>  	/* First check whether we understand local quota file */
>  	status = ocfs2_read_quota_block(linode, 0, &bh);
>  	if (status) {


