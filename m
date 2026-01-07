Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C1DCCFD641
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 14:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 868146B0093; Wed,  7 Jan 2026 09:49:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812046B0095; Wed,  7 Jan 2026 09:49:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 714106B0096; Wed,  7 Jan 2026 09:49:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61ED66B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:49:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2ED7B1B328
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:49:44 +0000 (UTC)
X-FDA: 84305451888.28.2870C61
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7DFA920005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:49:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XmDC6RSj;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767797382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9zPldPO0gnPG9wqrGk15pRMXLG4lDUH1uQahecjpaw=;
	b=NYW5v02GpirXgheYkM3DZLHjJ4ubbUUhisYy+MDowiroolUOUbvmf+VOj+aPobQ70eFJL5
	Z+UPbsBq+1dO6bKmOdbpuH/AuBk/kcZpNy2r7tygbu5jWY0vEH2bv5S9d3IpTc8Spea0jL
	YrIQWSTV5oxNmOzw2Fkq+sCaTxssfb8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XmDC6RSj;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767797382; a=rsa-sha256;
	cv=none;
	b=CV6FFM9cMf1bBtMQ9ckm5v1qP/oLKD9d9Y3dqmCtKGfksXEgxcfUgmo8v3trs+dkeSrIJA
	JHDQLWbEEU8f0DZNT0KdAzJ5dwRGzGisftb8ccucNLtTIfnOM3Hbke+rFWuIsioFWJBPql
	g5xpWb6IvTLN4ua6vCbOZOMhYtGEXis=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=l9zPldPO0gnPG9wqrGk15pRMXLG4lDUH1uQahecjpaw=; b=XmDC6RSjQjF/FBL9NZNvteRWSJ
	XfSf2hlRECEq0ebGyg5PpKJwJCMOSfzAKwNiq943mtTwN562XqVg6CXBQSWlSMPkQvBjMDvcHMIaq
	VbMaChEVW2NJrWYX+WTkUc4q69Qc5hAruLFHgmNhAYSWJ1vsrga7eXrkK796N4NMiipuPKZTZaOyY
	rFR/5UDT6V5KElXh5mZSYB1MBSII5ql1opBUYPQgnNho0fHqTuxPNBDc2lGvJn8XWN6B5G7rhA+bL
	5Nr/2YPyuCjvtoxt9xu77oRYLe5AYcNt5uU3ZpPNrjBz5lS//E3QOZJVBGISdvCI/NU5j64SAazKq
	NN8VbQ0g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdUqx-0000000DVit-44jG;
	Wed, 07 Jan 2026 14:49:40 +0000
Date: Wed, 7 Jan 2026 14:49:39 +0000
From: Matthew Wilcox <willy@infradead.org>
To: =?utf-8?B?546L5b+X?= <23009200614@stu.xidian.edu.cn>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org, x86@kernel.org, paulmck@kernel.org,
	tglx@linutronix.de, peterz@infradead.org, akpm@linux-foundation.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [BUG] rcu: stall detected in sys_mmap with PREEMPT(full)
 involving timer softirq and DRM vblank disable
Message-ID: <aV5ygyPM7J7VdmgL@casper.infradead.org>
References: <6b7e2fac.a60e.19b97034116.Coremail.23009200614@stu.xidian.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6b7e2fac.a60e.19b97034116.Coremail.23009200614@stu.xidian.edu.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7DFA920005
X-Stat-Signature: tj8zd7aas556gi4j68eqnfasan83hbjd
X-HE-Tag: 1767797382-136636
X-HE-Meta: U2FsdGVkX18oq6PW8DQ4lIQeW/ytvS+XzS8fM5NhsSpMtGcUqhc+3dkZxOOXCk/KiGH+mkWCH7GMmMNZ7AjQpMWN+tS9iYU9rsZ/dvgcWvQ8W3pScprURfNCIh55GDnGV6Ybev45HHmpAwIX1S+eFOTZh/ZgpzCRfHJVHC1O3xmT+UBmXyCwCFknmN4TV87PzsEEJwba7zzbJLAIfRQO56E0g1EsgAYYtUvA3gr/UEqZV7Ql7Hzn9JTrhqT2VzlZJ6jpts713r4qyUktzGmdjNw+m6YZeMGPDl5qcXxDviuJVFG6gOSnmOiSDAurvMss9hW8CzRqrO3AeB8SV69dJK5IH1qBgaNOFYwgWKE012IU8zFsi7jKe9ezlPB6jxHpGvuFEzTD/XEh3U6RAusJlfbIajqbZ/ueZU3vytnabQIrfE9l+gdQTLF+qzaSW/PFt33GUXn2ygwH0SBZIdhGTIHAKeXPBOXu37zR/HxJueD6jjanyTRwvJih2uVRWVEoqvd/o6UnlRi0NJzzjCIUXY6X4NGUhF8I4b/xBRLMLNpVH3Pekmm5/n+4T6TJAeCMpHcVHQTEwzSQIhOZyV1sYHpVlZb1GGN6g3XJOZSAeq9pImC2kDD08vNn5DlR/pEjjvNDU0Ii8aJXCP/F+/uNxPTOcnIiCbr0J35zGDHSPBiDSV59qaBQNO7tBKW+3KZ3zL6pT+KLs8dSv0cIUZehzaG6j3AN46crVBeW/4APQMuvVJQy3lL0nIBo0ad1aqOTDZnwvG2FB4eXGueAKYDt6VjsiKjOzQ/dkNeioHa51A7D003wsM9/veQV9i9zpFsPLbSZYqu2rYtfJb+5jAHT/bcd4VZ7+GFMPnjZiyE5O/XOxo2Ou8xCqnyrlENXOsVeduOPbDKRtU5EQl5IH7M4hsl8P178lqYWZYz2g7QMg7ntrLubX8DtpWCrV3yX5BzMAYQJm++swwBLeYHIwKm
 WY/pdOHY
 d9oIg4ehCXQO+po0sc5kp/zFDWuDG4f9XCH0Tt00BMIt++pNYpeZnbbeNl+Xr1a46JXRLhoxJtruFBu4qEC85qYVCWrWp2RoN8vU0bb6NI1uXglaYu8isnCx22OfUdQBdxGy6nb49EdbV6t29pZoNpB+X3x9Fa9lWRxtDJL74kEks2hTdaAbFCRR5YCjzVri972R5vWctOGXm/QfNMKXtplsuZJLdZVDJ1tW/ujG8ipt22f+30rlUIgIQyapfVM9DY5DY9eka/+LDN9g/WVKDthKzDixrKNNV3ukIXTAcjv1wACLgPPq37Eh3iVNjSRLbih6/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 01:52:11PM +0800, 王志 wrote:
> Hello,
> 
> I am reporting an RCU stall detected during syzkaller-style fuzz testing.
> The stall is reported while executing sys_mmap(), with the
> rcu_preempt grace-period kthread starved for over 10 seconds. The
> observed stacks involve memory fault handling, timer softirq processing,
> and DRM vblank disable paths. With PREEMPT(full) enabled, the RCU grace
> period fails to complete.

Get your changes into syzkaller upstream, don't spam us with "i'm doing
syzbot's job".

