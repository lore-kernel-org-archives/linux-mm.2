Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C235C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 03:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB94F6B00BE; Wed, 21 Jan 2026 22:20:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90F26B00BF; Wed, 21 Jan 2026 22:20:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE3FE6B00C0; Wed, 21 Jan 2026 22:20:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CCB256B00BE
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:20:34 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C9391617CC
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:20:34 +0000 (UTC)
X-FDA: 84358147188.26.CF6F4C7
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8DD92140002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:20:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=udfspR+g;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769052032;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31l0nbGeLTjwpa82UsNxbLyFca7m2KDZY12SuZ1x9N8=;
	b=1N+rahqrbjMquYuL6q8jBW+o7ttEItSN65xVnDrqBNip1nfk6AkdHO6rSwHcxh7rId5Uwk
	5N5IzqURB9vul56jYtLigopgESixEY0ys3WBerriHIn4I9rrsB5TELKhgo4xdKwjDHN37A
	M7vbKaAs+CFup7EZACquijBEPpezcz4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769052032; a=rsa-sha256;
	cv=none;
	b=zuoW/5OFd4GpWFP590WED0EwRDsmz0+3C26DraviUMPcqoibc9hZI6gayg+bJBV1ZtCbwO
	NkILi8IrZ5qG2Wp9IooJww0CaKwlfOUfu1uvCvOC3GvDyHP2K6PNe/Dsg15Fh8XJmQaymk
	TlsU2uabde74n6v2e7pCWTBmEOTUmbg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=udfspR+g;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=31l0nbGeLTjwpa82UsNxbLyFca7m2KDZY12SuZ1x9N8=; b=udfspR+g3unw93P3GndOy/qnL+
	k89TymW4jwCHYhiqN728xO1cj+Qp8izMTkfS1yJVokH3w6HtzXU9htJvTSZl2zKlVyLSvpH2+OElV
	KbgaY2MIY3P/rrSOipJbiAsgH05sCTLpEO7gv3OQUGTaswVXIkLizD4SSRGpNJlPh96eEfQEaenBD
	xe1iRDWBDMsI0A2yv1eQ2FqN94DWw8HIEHtRpFakIjsJNKDOMwSi3C4SeyVvOoYOly7DHiGvKuOeY
	nAnW6Owv5mjA6ly8KU1MMZ9TgfbSB5j235CCeD0BxPhPP/IEg9+eF2WdcBvG6pjXFYtfI2cTobywD
	HCVx3vfw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vilGr-0000000CsEq-1hPu;
	Thu, 22 Jan 2026 03:22:09 +0000
Date: Thu, 22 Jan 2026 03:22:09 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
	bpf@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
Message-ID: <20260122032209.GE3183987@ZenIV>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
X-Rspamd-Queue-Id: 8DD92140002
X-Stat-Signature: wuwxf7eifpjsit8nhms9oig3wikmqimn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769052032-395398
X-HE-Meta: U2FsdGVkX18+RatuerWA51S8iOX4BZEZjQX3XZpIpEsQn7Sczg8wNWf3ZrhwO+kE86gFRhszUcLEx3R5b04lx/soVwx/l4PA2SbWqAYnLXd8aWnGxQkOzZI/MjV8Q2HxNiVw/KjfmXrxvphlC43F1d7jsztQvWSlZaSkx3quykH/FNiR+A/1E4wN6/Jqesp8fEPjuhTpATttQc++X3Vl0iyz7MHOxSHppNqzQaKM5vo7+RyM7mAsAcKlT8HhCjABdkYRwbD1qv7suZmeLBn6SvCKTf1v3UCUwGTG55y4m6Dxv3Oq2Nzo1tWQhS84dZzvFRAXn6Y4IdwNncK7lSwepO3TXpQkKw6ZzMB9A1IZFLbiCPUNPF+O01QvYZ7ApfykeSLX4IcLtNrSBFlZ3FfBNFVEym9HdQSPiUpe7xhvzj/rf/CGB+H4Y6t8cFmWnI9bd4LyqMq6RLnO6fIGTfw9vsI982eeYe33JRNTcOuNs7ww9XLVfxcU4DoZvcV6ASi1k0OOxuruIzklARPYhTWEHKsoAr3l9kf5lHE5qt+P0jZIfxTxNl7afpUutgXldRg1Aj97WxQWGgCpLVktckm7J6Sm8CQMg8g407Qm3HkMX4iULbpWT9FkgOAu3rMDwXpFQ0Wom08Dr6fZukSYspsQ5O8RWjZnw8LW+6K/s1KLST9ww7FNoJ8KRZ43I1p20qev3PODNKYWI7XgoVnKEYNWUKe0sQa5/tNhw7/7ETeqQSi9svgrXppph/sKrOKE5xJOG6gnhYBD1LPquLNQarLDl/rn691RVa/2KqO9SLvTc6cy4SjnLvgSaX39uh/t3s7dffeXBGkme0MucBWFNDMDvgLvK1tOCWFOv6NBHgNCt465gbWdiaI0Pq3Lg9Ue3bUWrUPVt0DvUuZUw1e1RMFJ7ArDC09lrPQr4nYkT3XqI3jQD+ieYclPf+nWoOqbThMDOP6NjyB2tJ2fNs/cVSo
 MV6B0VMI
 I0i/2H1t8pMgQMZov5oeramBhxQO6KHynIH5bSh1pzWqnXMGIHyp++HsgPH/UnFwXpx+3ZymoHPKGjWmIcgIJcmEE2NXEk+Dq5/rbnmeqmZF00+YYlGCR1vlnI8oQ+UrmFs49ivCbKbo7KpY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 10, 2026 at 02:24:17PM +0100, Christian Brauner wrote:
> The annual Linux Storage, Filesystem, Memory Management, and BPF
> (LSF/MM/BPF) Summit for 2026 will be held May 4–6, 2026 in Zagreb,
> Croatia.
> 
> LSF/MM/BPF is an invitation-only technical workshop to map out
> improvements to the Linux storage, filesystem, BPF, and memory
> management subsystems that will make their way into the mainline
> kernel within the coming years.
> 
> LSF/MM/BPF 2026 will be a three-day, stand-alone conference with four
> subsystem-specific tracks, cross-track discussions, as well as BoF and
> hacking sessions.

Will there be an option for remote participation this year?

