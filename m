Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA02606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 18:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W9GnUFoc
Received: by kanga.kvack.org (Postfix)
	id E7A766B05B0; Mon, 26 Oct 2026 14:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04756B05B2; Mon, 26 Oct 2026 14:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCBB66B05B4; Mon, 26 Oct 2026 14:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6D926B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:18:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A6B0A0830
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:18:48 +0000 (UTC)
X-FDA: 85365588336.28.D6644D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2880EA0006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:18:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W9GnUFoc;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793038726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hF6zy/Y0w18f+U5+lO+T+mBpU9y/36ue5olFOfJt/uo=;
	b=kHIxl/ZX93q+spdw16O+R4NrVjG8LC5qRXPqfo9VDmu+Y34YP5p9Ja2gn1LHCNvY0Frfhx
	7aYQEYnd1x1d2xokpt9LmjTHGF94hZ9Mg/CbNySy4oeTle/iN24+QHXvJL6TnhSzVCjKoe
	lYXeSQIa9stQozEzFagqk1NzXV4rAGc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793038726;
	b=oeNp/S7pn3NUn3KDDSYhRqFOF6t0yRTQRbf49Bsgq3dqoigqeUlZIXSEKOD7F2J4hi7uYg
	ZArhOhFpkoBQc86XrUoSE1nw5CKrVwzgcV7/U7sEcPtl+BDViPpQdtgEb04xhzFI4yNZUp
	I7OIOc9S7VcRSoFzVi3f4P6ZeUCsKDQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W9GnUFoc;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BA2C601EF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77361F01825;
	Mon, 26 Oct 2026 18:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793038725;
	bh=hF6zy/Y0w18f+U5+lO+T+mBpU9y/36ue5olFOfJt/uo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W9GnUFocgwsxd9FmECRmMuS13L+i3z/j/5i+ff/vMPfHNfN5P2uwHVuqthdn9HP/L
	 fIyKKWJNGHCuksVDuMKvwwh9vUpBY0N1KbHC9Y2dt0Uh+ozXHlEHfnfMfjCEyAFzux
	 6bthXZXG1RnQonjMEcs/M/RDrYaLHejEdIDVJZNyo+BEucPqzeVeAZtmGgyDlYKupD
	 RJh2XcDQoY69BxDkPtnQX22voeppBJSHfwJSFYB5WLPbUuuFQDMtl0ct0tcswfYgHK
	 S1gmjO6TA8izLPdb34wJRY+2HnHo3sarTOikw0TWEKi1BFk20HbtTFdB97nb5ji2Ks
	 rmZ0TffR5xwZw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9A5FC198003A;
	Mon, 26 Oct 2026 14:18:41 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 26 Oct 2026 14:18:43 -0400
X-ME-Sender: <xms:gZnfajZ-BHts4MBHXWFnW-gFp81JJN1vpJiEKvdsdfrbKSJhN8knDg>
    <xme:gZnfamWIQGYuHM68Kd6jnmjPguLYksU5g4Jw_AddnVo2gcvKZ_0da_c7maXj23Hof
    _T8rAAC1UhevvlnBddDZKe3O1kxHrTrd4SMmYPOc2HfZ9Ew74LqzJnbcA>
X-ME-Received: <xmr:gZnfaucQ3h9h4FkGosoq6ov7rhDK0QujE015HThBnfJxyGvlZYeJK4tt-sA>
X-ME-Proxy-Cause: dmFkZTEC6jaU8WSvdlYj4erYp5aRUyJbFL4tgzgG/uQqFE4vkk2Ztkn6i+N1Ul3PwjXj5u
    D20bYcJ5jjhuGT8nryltaojXVsoT+8ZOnEMBt9S/7aS1YRSG7dsokqX+kHK4DEBIg4c5Eo
    5xlUdcBx/qw2dml5xc1tuTg/O+U3f6ne+q9J03Y2b95iSFa8NrzvpAM47RG8hhktz73InX
    SFDDxM0RUNrTg8iD0m2U31nVOYGD5BcF18/dItqb/iD5FcOTNFNOOeEgPKogiCBuWIZfgV
    iI1kRdoA4bLUgQZcqKXElpW7HW7jbsF9gaHt8mu/7Ht6wXzutN6KcNIZflodDM92pgq5e6
    CLBddXVbonCCpdm9uNlwGyShwzs1vPdX853BI882TVLTvRSFRDEjJyE/oZEeo89hKoY6Ut
    sRPvR0dpJ+IZx6OBXXpX/u99FYSgbXkvjNzjC7a3sq7f3ATNFPFo22uZZqB3nmQWJC0oHf
    dUpW1W+mUrrtc7GaGQUQJxeFY/+0Mo6LEObWdXzJ6bOm9LLFMjGJq1YmfF5flTd0iuaJku
    fLLV0X8YfRAppyG4sYKpGui02bQvVMr8lCIOBecMZVZTmW8q1HDHnIdD6nME48ZsPCN2Dx
    3kGIVDkAlPbzvruiVEZcky8DfF/YWgAoeauu8l/u2z/YFRtQh9ishjxf3Pjg
X-ME-Proxy: <xmx:gZnfajPNjG2RbHJxB75I-_r715n7cKOjptqf11wBj9HCFJW9PnwwiA>
    <xmx:gZnfamKDG1lQgXhV-HyfW2-wrvQnTb8NGhOkgAakKn6hIvmKN05Nwg>
    <xmx:gZnfapkOYsIM1ZxSuCF8K8UHrW4QN15-y51cOf1JB4A5lBr2FhqhCQ>
    <xmx:gZnfalbT2k_iMvQpQnfHXYxI2Um8QTaZNros-SDUE7Kl1JVTGxzFrg>
    <xmx:gZnfaohu9Vkucs2pLBN8yypcdtfw3NWKeOnFysRWS4miLEyctDXIPwEj>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 14:18:40 -0400 (EDT)
Date: Mon, 26 Oct 2026 18:18:39 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Hungyu Lin <dennylin0707@gmail.com>, willy@infradead.org, 
	hughd@google.com, baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] shmem: do not extend i_size when no data was copied
Message-ID: <at-XtWBQg3jv3H8Z@thinkstation>
References: <20261025164619.89992-1-dennylin0707@gmail.com>
 <at9xXRhD2xZhszEj@thinkstation>
 <xmp7ni65vbinfj4j2baisrhp6xzro3asbepuq7xp3mvx6maptn@r4dnoj63uw4t>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xmp7ni65vbinfj4j2baisrhp6xzro3asbepuq7xp3mvx6maptn@r4dnoj63uw4t>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2880EA0006
X-Stat-Signature: z9uz3pz7mwdjca9qy7t4xb45eb1p9k61
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793038725-472084
X-HE-Meta: U2FsdGVkX19AuFEoIL/wkGkmD5BDsapUCU+2pAj3aw6vPk3pU+KFqzt1g3kFexCURcCQ/JDKDCmd6IEZ7f82/iJNr/BFdZf2XbUcydSvLOP6RP5hTwIKfPAd6rBO7xMWFgKFUFdNJ1CB3ENwnnEw8kZ5YLeoWJjm/QgGOmcVC4ZgBQPcIqHWancBVmH06Fb0U+1LY4DPSnLs3qsZ9ajlwHeJmNSGOCq2eDKg4PbjI+zq/l4Ta2BXAWqPYjbQbW3XKcepKHSiEN2S1as7CCPIdNqqAKyn9QtdmAubZNdiY0Jt1QgmDSf6DLVp44XrB4dWg/Wypm6hyh/Z1q7RDxATJ8WiKach5hvisqCWdZdOrhZQxJQRYYmc2UKpCKYvIkqDqiySth+NUZPNvH9WR563VQ5gR9a1sTQCnzXoFUkjkIDD4+63yPfKlDGI7klkp8j+RuN9dfuT49GK0SuTbgCm2Tb4CU6jDIzKBLTeSgF8y/+jMZtnAk/MCdJWMGyX13Q5vj8Afk54ZhN7yjjbPBRCop8HXCgKuMLXUYWe6PYG0Mno2dxsQbxBT4egP1z/oz94ad3W8lB0q48TGwbV86XgfNwEhUVTcA0Km4uhLWcZDtvssYZSt7jiHAf6EUP+98PlMlioXwCZQwEzab8VXK+RVc6a9Wc3dJYWksgHv7fhF/Vzcoyy0l7dDuqhvQsbpaK1RNTtEWeD2PcXp8+4jcAZPb48IXy3cLIADUI63RL0IKsJBRrqcNkzeFCPtftqcswCtOeDeI2t/w52nfK8qF/bs7SFAk2uefj89AhHiJjTISwG/hwyV5pkXldrQHO3t0r74CdlugwgTby/4d1pPsJSMoGY7wfHuWfcDhdvZdz2T1+SNp6IjyutZiDmx044NghHKW+u/C46ZrIa8gytECfBXR79EKRI/6jZQwH0G5u+WpJyF2LGkPDpQ1TW5FzilXxk1+glvqQ/hDwN9f4ZDhF
 G+WSGIMm
 haUru3ZuYTL1/PxSLCxHB723DsAHOttFs0e67nRl+dqH7FTU0MDb5m+YklfGN/+jYUV5SCii3ERwGWHrrSkuIst7g/3LQciFlnRHNeQ4TxooaSCTlpEq86oSMpjoIzuIP5B377Fles9Sh19AULjifgjAPY4OgzBsydnRL8KycsHQx3vrVw0k/m0vWIc8T8uzcwJ5xEFvWpjzlTISk3uaZy4Pg4HAee92QTpXJC8a9kghJRqqV+F5gVbYNox9SSfGUcROnV4teMlH1LRdxe0+9q+b/L9QU7dbbp20FlsiI4i/JflbEVkLDvHqh99wiJBQ4u2tWzfwSRMaBe8iuWtSdcvKU4RQM723hR9ZCXyqm8XA2ZjfNuRvDJsY1jEw3qIDX39PJpD6C3uuqUnw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 04:48:58PM +0100, Jan Kara wrote:
> On Mon 26-10-26 15:34:08, Kiryl Shutsemau wrote:
> > On Sun, Oct 25, 2026 at 04:46:19PM +0000, Hungyu Lin wrote:
> > > shmem_write_end() advances i_size to pos + copied even when copied is
> > > zero. A buffered write past EOF can therefore extend a tmpfs file
> > > without writing any data.
> > 
> > + willy, jack, fsdevel.
> > 
> > This doesn't seem to be tmpfs-specific, right? I see the same with ext4.
> > 
> > simple_write_end() and generic_write_end() check pos + copied the same
> > way, so filesystems that use them through generic_perform_write() are
> > affected too.
> > 
> > It makes me think maybe generic_perform_write() is the right place to
> > fix it. Hm?
> 
> Well, that would be nice. But how'd you like to do that? i_size update is
> the responsibility of ->write_end and we have to call ->write_end if copied
> == 0 so that is undoes what ->write_begin has prepared.

Hm.

A zero-length copy only moves i_size if the write starts beyond EOF.
So we can bring the prefault back just for that case, before
->write_begin():

        if (unlikely(pos > i_size_read(mapping->host)) &&
            fault_in_iov_iter_readable(i, bytes) == bytes) {
                status = -EFAULT;
                break;
        }

Overwrites and appends keep skipping the prefault. It is racy against
a concurrent munmap(), as it was before 665575cff098, but that is
userspace racing with itself.

The per-filesystem alternative is a 'copied &&' in every ->write_end.

And generic_write_end() cannot take it as is: generic_cont_expand_simple()
relies on a zero-length ->write_end() extending i_size. So we need some
replacement.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

