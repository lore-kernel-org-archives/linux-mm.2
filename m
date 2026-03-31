Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DA381061B26
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 124116B0099; Tue, 31 Mar 2026 07:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5286B009B; Tue, 31 Mar 2026 07:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011F66B009D; Tue, 31 Mar 2026 07:00:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E86036B0099
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:00:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABF03160C60
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:00:54 +0000 (UTC)
X-FDA: 84606065628.17.5349C17
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 771B6A0021
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:00:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ZvVHS//d";
	spf=pass (imf25.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774954852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TNuT2cAuD0OlKPSarRBqH1oonNnIziA47qF4/GN+rec=;
	b=5116mZV1v9dTkZgoNPhOxgqdLYTSQGG5vxuEEYJt2YQ//iwUm3GnFRpAjnbbWskG53d7+F
	7gP4a/5pLPuyZv4s2dSjmdVOprOsQ+0+W88LFzIRTBcC0DIb7wzwwd/APxJTqxCwg/G9Ld
	ZeV5a838y3g5pQZ9FwJhhRb+KYHc1/E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ZvVHS//d";
	spf=pass (imf25.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774954852; a=rsa-sha256;
	cv=none;
	b=dabUs6YzEH4b8GViLwiRXRy2ynLsmOEja6OPXfAjFIDzMpul9Lpv8OuqzCoPDrYOIAkfRk
	pVtt7ADrptOhjei9GLKXh2RNTIpDtm6np3xfUd3nVoMxFCWxLxN0MsjbYGRf3I15dwEgzD
	630/kj3R/+elGLXZTXiMa8I/ZD3rsHY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774954851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TNuT2cAuD0OlKPSarRBqH1oonNnIziA47qF4/GN+rec=;
	b=ZvVHS//d76VApYp4knoqZ1AI4W7F7vTr7zW7bVEUfM+FAclmhmbT59lb6wtgh6xe/7dUMG
	LeezC24HY32fUOLCU3485eETgiZUkYcZHKUKBDuojmdyWg8C9lzWh/HnfPLYtrOmUDQqLN
	MIH7CSsbRewFyzLXd0C2M8HjF8bFgGU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-266-YDbL3fC4MyW1ulyVcUfRwQ-1; Tue,
 31 Mar 2026 07:00:46 -0400
X-MC-Unique: YDbL3fC4MyW1ulyVcUfRwQ-1
X-Mimecast-MFC-AGG-ID: YDbL3fC4MyW1ulyVcUfRwQ_1774954843
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C18301944F2F;
	Tue, 31 Mar 2026 11:00:42 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9385A1800763;
	Tue, 31 Mar 2026 11:00:33 +0000 (UTC)
Date: Tue, 31 Mar 2026 19:00:28 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v6 4/6] selftests/mm/vm_util: robust write_file()
Message-ID: <acupTAjkYf3USAGo@gmail.com>
References: <20260324013316.2590422-1-chuhu@redhat.com>
 <20260324013316.2590422-5-chuhu@redhat.com>
 <acZ4wTxSmPn_s_mn@kernel.org>
 <acjwcQjCP81JldAX@gmail.com>
MIME-Version: 1.0
In-Reply-To: <acjwcQjCP81JldAX@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: Atm7Y79SqMQd6vf6lWJiGiLz-riV8rBVLz1Tdb6THGU_1774954843
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 771B6A0021
X-Stat-Signature: j91z3tn847wkobnj1keze77kno9djyw5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774954852-28652
X-HE-Meta: U2FsdGVkX1/1CwxLSylmn82lHHB15o/PMC5/czBqHtYUiy63vTMBPCXMA9d4AxG4u+p9UaD+4328k3VAbydwPm6aq9SnL2pDut5wWwCVPKzRXjbqbho5Romy5xwNkeUXWqU2pS/mMkNMBz2Nxc9tznub4OXnFuay/xpKg7ooC0NrQpaFVoa7Su3OcTVuE1UR8/JbOS1rteNaNDs+z8RhLOIKfkHXh23keF61WS7OGNu5IyJpuujvFz/4YLaLD1BoltOu/CnnfXohaGE44xyc86nIn9iXbEifq81rUZsRtb2QczKJqOT0u9OTskufRPmDQjN8gpXbMOXubVrbEauJxovpOs4CB2iI3AwfNov8MIhmhQyrGpoXISJlntcWVzaud9Y23ADmX4RLaawblnxgg4OTLiMW4PpgC////hXOS9kfUcfmanWNyoLbmx4fRVEaORwfCNOxHDpSLPVIWNdFrHjVXRpoE/n05eIPJmdYdz3SDj1qn4+giRZ05ikDDPtQk/PGtuJgUmRcL6zKe+sJF04+oTgDfmrerDjzxldJWYgLga11UV8XsDhai95YOBJE4ck5lWBmAg7Anex7qmKa9skG4rXsToJq8EKTWmMdPUFsq4pwRNhrI0LP2w/b8ZpQTCb33/WINs2Q4VqfxTBkx9hXsH1nCu/lOsjtFcfTyT+H1EKnQ7eUzQXEM7FVFzDRE5dxXz6nMzQXMo6sTvZ+DNHXp/1m/maDSkiOGbnwYVOBwZsb4nrXqkHRxSHY+VqE5pBbtsUb53wMWatjQqwJdkFHpv7yCfh4AFEaagR2QCFASw4S0nSYaFCDRcD8Db/H7eXP8duFyI1mDWRxdZbN+xfHIIvZkxKWuB4cdkZC2miEXf31SpugJwbV4U88GXd1O42/sB73hWG+FeJ/9pnaUESA9ziMemW9EqANvL7WAbZA/hp+x/Lv3hlk0c1tIBrHeRcY8wt2a5ftHgwYeMX
 mSIUUvUW
 UKQsn7dYcblaHNt+4iiiGcn7gEM04525ybsiWlyxpi123vvTPhDsckC/aIhWI80cujjJX9tHOrve4D+KkKkRouUW06tpJggk5U7GveBzMXYPHNCW8p7SQNU7nhTMmKyDiJ7pO03C4kt6e477hqIg1lceMGdxpu0oM9FOBgGOewlrfW33fGMUzjCmkc3MydFrdEb7BCd0fgNfLciW0kWFwkibJ/bMZKJhkLGYE/kdfDAVvt8nafSUt6McjVwFvU8i8uLGaOmzpL8Vxm6LSItQKEhMBekHwxi6MWmXw1hxgASjh8DUZrq8AXrBDzFWYQwhmIMNy2k4n6QIaYw0IMUCKgXfnwakL5YdRVtez
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 29, 2026 at 05:27:13PM +0800, Chunyu Hu wrote:
> On Fri, Mar 27, 2026 at 03:32:01PM +0300, Mike Rapoport wrote:
> > On Tue, Mar 24, 2026 at 09:33:14AM +0800, Chunyu Hu wrote:
> > > Add two more checks for buflen and numwritten. The buflen should be at
> > > least one, otherwise the 'buflen - 1' could underflow and cause trouble.
> > > The numwritten should be equal to 'buflen - 1'. The test will exit if
> > > any of these conditions aren't met.
> > > 
> > > Additionally, add more print information when a write failure occurs or
> > > a truncated write happens, providing clearer diagnostics.
> > > 
> > > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > > ---
> > > Changes in v6:
> > >   - save/restore errno before and after the close(), so the log could show
> > >     the correct error info on failure. Suggested by AI.
> > > Chagnes in v5:
> > >   - new patch for making improve on write_file. Add more safety checks and
> > >     diagnostics info in log
> > > ---
> > >  tools/testing/selftests/mm/vm_util.c | 12 ++++++++++--
> > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > > index ad96d19d1b85..572ccb99de8e 100644
> > > --- a/tools/testing/selftests/mm/vm_util.c
> > > +++ b/tools/testing/selftests/mm/vm_util.c
> > > @@ -767,15 +767,23 @@ int unpoison_memory(unsigned long pfn)
> > >  
> > >  void write_file(const char *path, const char *buf, size_t buflen)
> > >  {
> > > -	int fd;
> > > +	int fd, saved_errno;
> > >  	ssize_t numwritten;
> > > +	if (buflen < 1)
> > > +		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
> > >  
> > >  	fd = open(path, O_WRONLY);
> > >  	if (fd == -1)
> > >  		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
> > 
> > We have ksft_exit_fail_perror(), fits great here
> 
> the ksft_exit_fail_perror() don't accept the fmt string, it only accept
> a single string as parameter.
> 
> ```
> static inline __noreturn void ksft_exit_fail_perror(const char *msg)
> 
> ```
> 
> But we can change it also support va_list arg like 
> ksft_exit_fail_msg(msg, ...) does:
> 
> static inline __noreturn void ksft_exit_fail_perror(msg, ...)
> 
> I can have a try in next version.

Tried in v7.

In v7, I tried to change ksft_exit_fail_perror to support va_list args,
and I used vasrpintf() to print the message to the buf and then pass it
to ksft_exit_fail_msg(). But it requires _GNU_SOURCE can cause a build
issue in mm-unstable tree from the kernel test robot report. 

The vasprintf, the static buf[] (will trucate long message), or make
a copy of body of the ksft_exit_fail_msg and append a perror string,
none of these ways is clean, using ksft_exit_fail_msg may be still
a better way.

What do you think, Mike?

> 
> > 
> > >  
> > >  	numwritten = write(fd, buf, buflen - 1);
> > > +	saved_errno = errno;
> > >  	close(fd);
> > > +	errno = saved_errno;
> > >  	if (numwritten < 1)
> > > -		ksft_exit_fail_msg("Write failed\n");
> > > +		ksft_exit_fail_msg("%s write(%s) failed: %s\n", path, buf,
> > > +				strerror(errno));
> > 
> > and here.
> 
> Same answer with above coment.
> 
> > 
> > > +	if (numwritten != buflen - 1)
> > > +		ksft_exit_fail_msg("%s write(%s) is truncated, expected %zu bytes, got %zd bytes\n",
> > > +				path, buf, buflen - 1, numwritten);
> > >  }
> > > -- 
> > > 2.53.0
> > > 
> > 
> > -- 
> > Sincerely yours,
> > Mike.
> > 
> 


