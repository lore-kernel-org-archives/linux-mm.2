Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6FD606A335
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 22:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=FQkQmRsM
Received: by kanga.kvack.org (Postfix)
	id 786556B00EF; Fri, 20 Nov 2026 17:16:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7377C6B05B0; Fri, 20 Nov 2026 17:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673D66B05B5; Fri, 20 Nov 2026 17:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 465C76B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:16:25 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8586C01FB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:16:24 +0000 (UTC)
X-FDA: 85456907088.14.30B849C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7D933160007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:16:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FQkQmRsM;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795212983;
	b=Jj1SZRcd3IJLw0z0t4oV+3EJSqdgkBxVduTA3RgKpi87kcHOTIa673zMc74tEYbhFR9Rgq
	/S7FtPzTypCyHVwFfS4+IxrrMq4pvzfmKBr86V7Jrzv0um48m3JP1lEKaAC0Ez5viC1jcF
	DWi0KrIka0bbeaMx+kBP3AglUZMAfTc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795212983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWQrNtFyfIXnHGI2fRFmH9GGodaYvK+4ToZmzZlpeLU=;
	b=wRKcI7LB3fzkR4OaPWHN/3Zd/mYVRiXAuz0RYxq9SOU76S9drpIwPdl4fRv9tNRtlSsWkb
	dUChzbqa7TJ7dzILnOeUxENp1fPuBB9994Q5kKzw5asq64ZHWTgjikFbhghOIITGDITYbj
	lWuexxpr5RB4ub+33mlu6szWci4Lmzo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FQkQmRsM;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tWQrNtFyfIXnHGI2fRFmH9GGodaYvK+4ToZmzZlpeLU=; b=FQkQmRsMZzJVVSot5NtT3VpROy
	9IYHajkK2iNAP0E44KiGPStuPGv/oU9aQRsIikSD9/8OzUDBp41S+XZBWKFUIEvlEvq+g3ye+X0Sb
	3Ie3KEmgLvsC03wA7MT61P/wiXuZ9aIfm7IllWctx4Hk6TaudOeuw8+WK8Z3edhZuxLvV+x2B3HN1
	6OmXWZ/hdHhzwieWL8XtYZ/Z/RsJ1sQc+cbjMtL7oaAttwrzfDAqXxgJPVIej6ldnfzdaGrnIKUhO
	ANqtjLDihyjUBnzaviLMdHNfrph5loPAshN0YPmlXezfUrirKby3HXXywH7bAV/XAjv/zLx0kyAEv
	5WyKOspw==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xUWu2-0000000DBrk-2nDY;
	Fri, 20 Nov 2026 22:16:18 +0000
Date: Fri, 20 Nov 2026 22:16:18 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Tianyi Chen <hi@tychen.cc>
Subject: Re: [PATCH] mm/filemap: only drop dropbehind folios on uncached reads
Message-ID: <awDGsqkIaasAjaNB@casper.infradead.org>
References: <20261120-filemap-dropbehind-read-v1-1-a373ac3fd993@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-filemap-dropbehind-read-v1-1-a373ac3fd993@columbia.edu>
X-Stat-Signature: jacz45mfkpchs9inzdp8d1jr8chjq4id
X-Rspamd-Queue-Id: 7D933160007
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795212982-595273
X-HE-Meta: U2FsdGVkX19OPBQa+yuSKGMFZMH7oP5OC40obhkXCoW18cH7KLvVdLKDBuAQ9HI5705mbNNXevz0H98H1rCs1xhJTNiKyqewtjYIyNXjWQoc9+A8hLsNXbGys5mAeCCZ1b5PgzabQrHi1V4vu9SvtaMLaerBEJJI535yO+6d008Fw1cYpBIzs6+wF0t1dTEI1CXnZ2cfXPO7wSbK3DfbZynxPxUIW3/Jip4GXDaz7mXqiSMuAgjtixeJDkMAWzCUHRG06TrJf6dbZhc2X3dkJdusdrGQNN8xk0iUMsYSVQyMAWPXTFc+gd8Ym/daAFD40wmG86UxENFElX7gS388QvBf3TBVAoZJ1cO2WdYyzRIGRFFiMgRpyfHI3fZne5gkh6hh4HeUBzNvfZf0Fc2haAaK1lABqm29iEPiWnOwMF/vq7mX5lS628o9IKwpf4rDmYk/Be3TTUMf/Hmp6JUIgzug2HsPRJA//0OUN3gQV9jacuBotzytoR4u1hiEu4R1roVclwnrDeSPKheVmq7pu4wr17ujeSby6zH06gCh04Bw0teG5nQtB1pXo7idKifysUMX3NICjtKoweopupCYV7hzTqOOSz8mDVCh89YAUkWDrWyR/7VIQAaA3/0QluLvZRj6U7HMO+aIsxu/jA8gIjS2owxRsjVgkVePQfdnr4Yax8mC1Nld2uX+sCmcwFsVVyPpRcCNFWBhcW3LnyqQ17vhxMvADnlV2CzMmEDYcdzD21uNnLuGT0B99B/cl+A3tZ0U7VsuC7//Dn+OG0V9XcJpK0sE1aSUuvXBRGGQIJ1U15zkyZxOXlFoxgJjXk3Yl/vI/eg++0M/JFlw7aPXe4OEFMZs4ENWBN0fEeEIzbtwKZd3OxYCjCTDc5jzBB3xAzM/UrHF+/QhtXt6mxZs3tF2fcEwvdoH0We7ZoxyC9xsp7hY1kFbu5/Xk3SUInBWE+IeJ8uMs56GuBLuhlg
 qMEQd8dg
 dKKbOnc5ZUHQNgb9geRs4GmwOnaLo2sUleqfLIXKNaU6FkrPKeVGBTBig88AVQhflpwu4yeBA3Bl4XJoRas+tTzbr7kNRLj+6pQZqt9gihSlYggn1QhIOMv6NsczVuYyt8+mwN0nS1aMxZzmfkMmlwk/NLiKHp4jXo146bpENBDhWsHnQv4a21MKgEaGZP2Sd9upFbu0KsZsjuMF7TmFR0jbc6SS9SSm4EMfckeCuqQDySLCII1TLcWz2IXugDhJc5v8E/iISeoUDQ9KrE68aT7E6pi9396R41RK3+EHa5ZiEUiXqDiU63Lt37QPJoe+a43A8TFUFcGTNaXBYo42Etwr8kEphjTbzE4+HclGb9wLeiaxeScjJWUI0HL2MVupHbZ4PtbobidljRDc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 02:51:17PM -0500, Tal Zussman wrote:
> An RWF_DONTCACHE read marks the folios it brings into the page cache as
> dropbehind, and filemap_read() drops them from the page cache once it
> has copied from them. Readahead can bring in folios past the end of the
> read, and those stay in the page cache with the flag set.

I like your patch, but now I'm wondering whether RWF_DONTCACHE should
trigger readahead.  Yes, I'm sure we want to use the ->readahead entry
point for filesystems, but I think that an uncached read should not
bring in pages that weren't specifically requested.

Something like this, maybe?

+++ b/mm/readahead.c
@@ -590,7 +590,7 @@ void page_cache_sync_ra(struct readahead_control *ractl,
         * readahead will do the right thing and limit the read to just the
         * requested range, which we'll set to 1 page for this case.
         */
-       if (!ra->ra_pages || blk_cgroup_congested()) {
+       if (!ra->ra_pages || blk_cgroup_congested() || ractl->dropbehind) {
                if (!ractl->file)
                        return;
                req_count = 1;


