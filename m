Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21E85F3D5FC
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 09:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D0A6B008C; Sun, 29 Mar 2026 05:30:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874916B0095; Sun, 29 Mar 2026 05:30:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1946B0096; Sun, 29 Mar 2026 05:30:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69A6C6B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 05:30:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2282913AE2C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 09:30:40 +0000 (UTC)
X-FDA: 84598580640.01.16B08F6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2556140005
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 09:30:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LGvgKjx1;
	spf=pass (imf04.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774776638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uSEV5DVnX6Qaz2dMrSepuJsnEsG/Qes4vX8oCOHtAp4=;
	b=WzgA/aDU3uG6smABJVKVxyzMQvU2yDXpIemFSfNoR1wt7iELljD9kleulCd/0kcHfi8ipy
	Z7M6/E+V6Ywnj6SY0NFRJ/o66XaqlncS2HGgIBU5rQXzmQ2EenACh1lWSQ+HrB9TSGlVWC
	PN5hLgam/eI4AIX5paCNhFqzn8UQsE0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LGvgKjx1;
	spf=pass (imf04.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774776638; a=rsa-sha256;
	cv=none;
	b=q5+82qk2CGszFXeGVE2fcc2Hq0VMilLpEJWPFp/ccGfDwVJ+r3XYkj5L2awSYxK6Z/6ch4
	krpr1FNCku0vxoUk3su/FmEoM6jntCnTi46yzUpnSyeeH6ptGelsoV/yohjyVOAnEz5nbR
	6jTjUa3iGFcF/NASYybnqUsamEz7bOA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774776637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uSEV5DVnX6Qaz2dMrSepuJsnEsG/Qes4vX8oCOHtAp4=;
	b=LGvgKjx19vBKq39aQ/iDusJjnaenxRHP6kYFp3hpmz/DmWw0aoNEROAvO3+ciyq1MEce8f
	+cq1PVKlQGYOT/Z47j2mXhqk41XC11MhC7BX7av/yWt7PAhAAu/S1XxnQoBcz2xPvibxbC
	UZEWigIBGM/+YkKCmglR3RhDdbn8G5k=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-347-lfKqZ1nTNFCGNRSlxwjkAQ-1; Sun,
 29 Mar 2026 05:30:33 -0400
X-MC-Unique: lfKqZ1nTNFCGNRSlxwjkAQ-1
X-Mimecast-MFC-AGG-ID: lfKqZ1nTNFCGNRSlxwjkAQ_1774776631
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E7A1D19560A6;
	Sun, 29 Mar 2026 09:30:30 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.11])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90D8430001A1;
	Sun, 29 Mar 2026 09:30:21 +0000 (UTC)
Date: Sun, 29 Mar 2026 17:30:17 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH v6 4/6] selftests/mm/vm_util: robust write_file()
Message-ID: <acjxKfDnPt3YhsQN@gmail.com>
References: <20260324013316.2590422-1-chuhu@redhat.com>
 <20260324013316.2590422-5-chuhu@redhat.com>
 <c87111e3-5cbe-487c-90b9-78d22a3f7a24@lucifer.local>
MIME-Version: 1.0
In-Reply-To: <c87111e3-5cbe-487c-90b9-78d22a3f7a24@lucifer.local>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: LpDYccJ_hIRF5yX8EpCbLvmGfd9MmJVEbNvuKkKSdYY_1774776631
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 2556140005
X-Stat-Signature: jgrhccu4n65j9xwuqek7fywr1r8y44nq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774776638-710882
X-HE-Meta: U2FsdGVkX19NqrT3RBhq+vhei7Q86rg0zAC2t3Yura6KNLYGYJuiHCJ2AmoIVJzAXG1HdmVNdES1dpHegX4/P3iEMSBL+B6Dusw0Bse383ZFlO3ndia2uGOGDzOD9MtshTldtljpqLstgO40e7evEKg8LycSMDa6xReRus3PDO+6OOkAkAN2ghdNXaj//qDU4WwRYMwBTvOfMH5KfM8lttD5lqiEbucbmJ/s2X07UvozaWCvjX6hkFSI0l1HucTMaxfa0JT8CUZ+XlKYNLk4KUR10hVwOpgmf4Skig1WrgkdIhgDR4S1+i9AkEJMKk8QwvQxb8q4kAs+f/aYhDZxKGTWSKWDof/9eGaoHfNintkKpoVmddEXe1B0ZB/1YXCE30gg/b39u+C4eTtRRbLlvcdyfigLLnoVVhUwqd7CYX9UoxpiaoHk91+D+wEcyggWX9ZKbymnocKS/BO4r7tjXX2gGMpZWLxaaPoZlKHnw26gHNfVyVoeUP94ratAZIyjRaGu3zen9MWyEBSf8y91boeHqZjczd+KpSd/wbJOyYHSAu/NsxNY014HCYcMUM5C3WAf09lAJ7FI546p+EFRf/Ky3bQYmkOG8gU0HBW6foYRADNMvpM2thuUxUw3GshlPCWEuBpkUzoWyxaoYmEpmq9dpepeJ7o7Jkh+LAW+89fC9TuE8vnrsrTxDDH0bDrpw6MqoteVfLMx0xEGmos4UiONZ6TCB9xAxY0/tEqBxkSSrbVGpBi+6DSKbmUH0VHaei4oOOwyTQgLCamBu74mhtWTfFbufohCuvUffo2bmgBSZEjj8hd36fRAT4dgyINAmvntm8jrYwbhM+6fOwfoLknyJhyhpzQTjgAmrtYSe7Zm+COi44wPUGU1xtMo8Hz6hXSxJIq732ux7cGCFIfsiqMHOvkVu+FiZM80RDSXZZvYWNwDQBLW/7ppLDb7mTRRLVe6l3DEGT0rgzxP+wn
 tZnsSeJi
 +sIri40yR2L+YQuqloZ4ydjXIvPZSWCZCrvfL8lKXS38R/Wb6f6uiGJEbaZx2fbDuiijmLbPMqA7jMoBCRncvJKNZ86UAB40H3tmg1aGf1Su6X8vcR1UozygwNaO7r0p9eAslL1zcMHvkqdVXPPPUuZswgkOyVzYh3n2d2WbFrv3IWZAQ59TReZmSWFE6slS6UFvaKyA5RVHJ7KfMvfOqH8gDnYscWv0h2xAmtOvEu21hKpmLGe/FI7uzhKFG1/UHdPwRuJOPJM51L7Aq7zRDTsiLvVTn3BbY+ItkAH0V22AZ3j2ZZUfXntgEkI3tq0yMEhLZmtNsq2sX0pwX1KTf8xx5B2ItYnS8Owe+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 07:46:03AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 24, 2026 at 09:33:14AM +0800, Chunyu Hu wrote:
> > Add two more checks for buflen and numwritten. The buflen should be at
> > least one, otherwise the 'buflen - 1' could underflow and cause trouble.
> > The numwritten should be equal to 'buflen - 1'. The test will exit if
> > any of these conditions aren't met.
> >
> > Additionally, add more print information when a write failure occurs or
> > a truncated write happens, providing clearer diagnostics.
> >
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > ---
> > Changes in v6:
> >   - save/restore errno before and after the close(), so the log could show
> >     the correct error info on failure. Suggested by AI.
> > Chagnes in v5:
> >   - new patch for making improve on write_file. Add more safety checks and
> >     diagnostics info in log
> > ---
> >  tools/testing/selftests/mm/vm_util.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > index ad96d19d1b85..572ccb99de8e 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -767,15 +767,23 @@ int unpoison_memory(unsigned long pfn)
> >
> >  void write_file(const char *path, const char *buf, size_t buflen)
> >  {
> > -	int fd;
> > +	int fd, saved_errno;
> >  	ssize_t numwritten;
> > +	if (buflen < 1)
> 
> As per Sashiko (presumably didn't look :P), let's make this < 2 since we
> write buflen - 1 bytes below which we don't ever want to be 0.

That makes sense. Let me change to 2 in next version. Thanks!

> 
> > +		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
> >
> >  	fd = open(path, O_WRONLY);
> >  	if (fd == -1)
> >  		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
> >
> >  	numwritten = write(fd, buf, buflen - 1);
> > +	saved_errno = errno;
> >  	close(fd);
> > +	errno = saved_errno;
> >  	if (numwritten < 1)
> > -		ksft_exit_fail_msg("Write failed\n");
> > +		ksft_exit_fail_msg("%s write(%s) failed: %s\n", path, buf,
> > +				strerror(errno));
> > +	if (numwritten != buflen - 1)
> > +		ksft_exit_fail_msg("%s write(%s) is truncated, expected %zu bytes, got %zd bytes\n",
> > +				path, buf, buflen - 1, numwritten);
> >  }
> > --
> > 2.53.0
> >
> 


