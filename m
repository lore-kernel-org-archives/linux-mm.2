Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5498CCCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B25388E0019; Tue, 11 Nov 2025 13:46:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC568E001B; Tue, 11 Nov 2025 13:46:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3FAB8E0019; Tue, 11 Nov 2025 13:46:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94C458E0019
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:46:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67533129CCB
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:46:05 +0000 (UTC)
X-FDA: 84099205890.13.A07F10C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2F0DF40009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:46:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=P3JxL1nx;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762886763; a=rsa-sha256;
	cv=none;
	b=yV5eaxeXUdc5+VVNwUh2o1cWcu0ezLv7c4yva0Wg1A4Nmup2WYSlfq2TLO8FOKy6iRu2Yc
	kmi2EuYFjXt4Ry0I1NfNiBXElqqXyK6FeM8qgavNf40nFZ4SG17rnPS1OFqMjqgh6Y46Uf
	7gdhKrpxEF4tBVnrauV6C3oGHgqfEVk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=P3JxL1nx;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762886763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=87AGEWskOWuKD8bTn2TMtYTHJt9FBx5sBjo27mIhX4E=;
	b=epBmRr9oaGsv253JvaGziPScmsbHPvbYQCj6CCD9JLYMEZ6Xwo+wzhl7Pb+mPm+N5DchjT
	NeWd9BcT4w8+WlRZurQQpz7ro1h4r3mYtLe8Sa0FIY2xEzKIcmT3l005dYxWS7YARQtYaZ
	IAeQeUlFwpTCNs6p67tM6TLfGEMB698=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=87AGEWskOWuKD8bTn2TMtYTHJt9FBx5sBjo27mIhX4E=; b=P3JxL1nxVNfIf32+302Hw1gZzw
	OF7tCr9psj46nfmXab1VWQL90Ib8k25YTZbi8r88SGymdXbjVAGxaAbpux6ngSKBOZIAd2cPfxyPr
	EZQIN1VXpyfBGCv5mEHkgq2qcPqtEI+/sK/BBLtFnJybq7hnKBCtHaWQ0Oq7LAOCuFqe254FUD66b
	10ETTLrcYe0rWu+kjo7VsYQwQWdhO8QoAM4rKlPGzufRJd/PT4R9Y256zfcO9PUh4Olja8War6I49
	J2H/u8Ye6TV2mm7rIowULwLczq6YPw4h0/dGzok6p+D7VJxKDBjvqMCqFqvpz39k248KoxSggRh29
	f17unObg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vItNR-00000004i7O-1BBT;
	Tue, 11 Nov 2025 18:46:01 +0000
Date: Tue, 11 Nov 2025 18:46:01 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Vishal Moola <vishal.moola@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH 4/7] pgtable: Remove uses of page->lru
Message-ID: <aROEaV-840d6ZP7L@casper.infradead.org>
References: <20251020001652.2116669-1-willy@infradead.org>
 <20251020001652.2116669-5-willy@infradead.org>
 <4f7a1501-b10a-4047-8823-a31a68813424@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f7a1501-b10a-4047-8823-a31a68813424@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F0DF40009
X-Stat-Signature: a5pgqe3thh7eh5dch8rsaxjy3w6xycgp
X-HE-Tag: 1762886762-320235
X-HE-Meta: U2FsdGVkX1+uJrX9NvwknWVUD4t+W7+suV8x9HrfYeHIgrYiUxcWNyvj7sOrWOYR6h+33xQcp5Lqim3K2z2JDKIlE0+Z4QhpCZzwhwV6kPdfua9ERwWUWdcoF9CNinWquNyrPfFRpQL+zS7lLhIOOUEEAuMGAm0UpoQ+AjsEv7k0ZxEanF3RdGP6jJHa5kn4LU4OA5fvq1yU4CCT6rVXp8l0hh85ZwVBktjSi6UO6tguzMM/Y+smxiLStJkgwWK6kII/llYNDSPxJx6ZYjuDRRpaWt82Qi7bw1rw9f/IW8TqZz4cZuUI2l/iSP52n38ipsaS8w0Psp6H2E8fG4zEAjigHh5dAv4hm7mz8yeqNiT8HVG25jP6ymYR/EGbWGxczgRRRBKkyDKgEK0DbigmqqOmc5J+f0Mdeos0LvZwO9rP1a6HyAtAPYJdAX8bA5+I7GStFP9cYQ2T/ra3RgLR+aXKQ2UKxP0vHc3pVhVWUUel2tonIztlp/EIyWC8V2wcQv0bFSALdGE8Wkkaa+R1bWF5IEr88gXt2+4d5Z1x2rHqxYp04EeNwjxZAY+14K8ud5BisYTN9odZU8zVKRPxXSrkc89o0RlYenwbCx9gLZ5Imz0F2v/9oSJm9GucyioKCJivTKWyEhW0ggMJxMo54CWju/MfJneHgsX6YbpnsZ/d/HyARjZVW9OYiKR8A0hllZJDMq9QtUX4O/tDvcrXp0CIPiwAaA+7vZK5yddaEblo3IcSj7JlObC46gGMqKM+1vmIcdvW5x2Y7RB4dkadydcp6efnbgAoIA3EwfOjYXPtXHlAS4WoBYqwVZ5JcJuJKBHMb0o2H1WD/Q1lGYcGQdTVe06buOGnxMYGleZNuulAzsl4dpL1+8IHLaPeOKBfaiKiefPOTPqvgtvqqXArA+uSIwW7S2zaetyzL5iID3+LAvZ2lBfvmKzhRE9csBEUzRS/PjX5wX+PIC7BfeH
 QFFBwaXE
 GHP/UI+l6CLJ0X0uotCDR45b0sRVqWN6/rNc4igtMPSgdje4w3P/iP5qw9ESUTeE6E/Wb/uLVqd61QRfbjXXLVMo8L0k3S36MF7vIM24GhkAPJEniJRDjAym0DC4Xsx5dg/iI5cuoqdB6Jf3TzmPUHfAtb+DEtmma6V7OaxSAVCgCt8dPjlMNa9rT6+fFTABl/a2e6RswWYpTgxOSLC56WgoUzjyAMjZuXcuW8OoZ8zAElC7QiP76IcC1QAA0jZdU4d+4IeAbeZSOW1Gza3tIiQtLy/k7QeyvgqBX9v36N1BMMDM57v8TA6alQ3coITT+ur5l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 01:23:53PM +0530, Anshuman Khandual wrote:
> On 20/10/25 5:46 AM, Matthew Wilcox (Oracle) wrote:
> > Use ptdesc->pt_list instead of page->lru.  These are the same bits for
> > now, but will be different when ptdesc is allocated separately.
> 
> Just wondering - should a corresponding TABLE_MATCH() be added untill
> those above bits in page and ptdesc remain same.

Huh, I hadn't noticed that was missing.  I'll put that in as a separate
patch.


