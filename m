Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AE64CCF9F8
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 20:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37D388E0007; Sun,  9 Nov 2025 15:40:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354DC8E0002; Sun,  9 Nov 2025 15:40:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 291AC8E0007; Sun,  9 Nov 2025 15:40:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 128858E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 15:40:32 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B10754C4D0
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 20:40:31 +0000 (UTC)
X-FDA: 84092236662.30.41301CB
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id B0728180002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 20:40:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=wUuaVauM;
	spf=none (imf16.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762720830;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BfmRhkxrsEs9tOM8wGbk7dXcVXNceBqTXcIhtt2SrKs=;
	b=Ia3iTUqDWtYineZvybI4lUi+/muv2G6XF7uRjE7x00hiap7r5z54aYTj4tgWUonk6Sx1Mc
	tFoArfjkaZ4rl+k6GX05ccLlcEbQ0pXOh+iiqg3IP0paHR5wwKgrRqoQtc/66VnbSUwvQo
	79ZuKg1yjp1kxnQTN/M8Q8bFFzVZlyk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762720830; a=rsa-sha256;
	cv=none;
	b=bNQiq4fQkqO3gDof7ocFE913Q35JrIGtvhldVdsBWrZs9HVRwiEzZdxMnVAq/9thWHd5Mw
	ID5JtOUNus4LgoU33frr0XUdWKS1+hYJ8MgiGLKOJWYH63V34YoGFhMC0+SVepZKb7ZCC+
	+iYk328Q78Dn98+GSzLpq/8FcW9pCm4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=wUuaVauM;
	spf=none (imf16.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BfmRhkxrsEs9tOM8wGbk7dXcVXNceBqTXcIhtt2SrKs=; b=wUuaVauMMR7ErCaLipgahv02uK
	f8zmYZUSkXrkSeIWVD+p2We+E7S0R1h/RkWnDRzYS23UkSGwmELAbRJJxSREYjeqifZdYxQ0MI7Y8
	whP1b+2iLCrarO1lAoXJmD7YCetyf1ykJN7sVe3HCohmhOOvBIYllaLsgF2qgYoPuJ6bpGVgIgYwX
	WVTBkowQ1Lmcdjvk4p6fM2kbY7LuhZft2NVC8ulf4OPzi+fEUEktbxyTH2D3vg2+jh6CBx75Obxt7
	6/7552MEzeebUdxzenriy13HTG10/jzbqdfcj+Rdt/3+FhTjfYrzTwilZk/MP+73IUGSCKVk2vREG
	7z5iDtNA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vICCw-00000007AxF-0Wo7;
	Sun, 09 Nov 2025 20:40:18 +0000
Date: Sun, 9 Nov 2025 20:40:18 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org,
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: Re: [PATCH v2 22/50] convert efivarfs
Message-ID: <20251109204018.GH2441659@ZenIV>
References: <20251028174540.GN2441659@ZenIV>
 <20251028210805.GP2441659@ZenIV>
 <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com>
 <9f079d0c8cffb150c0decb673a12bfe1b835efc9.camel@HansenPartnership.com>
 <20251029193755.GU2441659@ZenIV>
 <CAMj1kXHnEq97bzt-C=zKJdV3BK3EDJCPz3Pfyk52p2735-4wFA@mail.gmail.com>
 <20251105-aufheben-ausmusterung-4588dab8c585@brauner>
 <423f5cc5352c54fc21e0570daeeddc4a58e74974.camel@HansenPartnership.com>
 <20251105-sohlen-fenster-e7c5af1204c4@brauner>
 <20251105-vorbild-zutreffen-fe00d1dd98db@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105-vorbild-zutreffen-fe00d1dd98db@brauner>
X-Stat-Signature: 17egjwhocdc7ynrk5fboq38nyo16sixe
X-Rspam-User: 
X-Rspamd-Queue-Id: B0728180002
X-Rspamd-Server: rspam01
X-HE-Tag: 1762720829-552053
X-HE-Meta: U2FsdGVkX19vDeT3l0GWWWKbdR7JnWsvb5mBG5NMPUSFgaL5WX2uu6zQhLOT6oKr63+JHK1X179G42DexCQw0Lfsag1WaVRUrL82bNm2N7m5thfPCNRpwhmNQ8bt30vdn+y6mzq2dIEPpedLLf7XSmcFYHtk8Qn5ka/AcdXp8tXyfMqEIKZcbSRMWopTTwcfaQzDB77tsa/MR9J8vASOMhxldP3/8dYyBMHWLXH9I1ozFT5/tA1EG9RdaPlWMEdCwHI76m8KqjN5SPMOWP1m3qtAfPe79EQBpvTOsW0wxFib0Rtn6/LZDK8tEKMlsZv20PWMoTfVtufKomoRFtzupsS5sA87qtGDcomNDwkTHWBo059Waz6LX4qoZE99/bg8ErFNGZWYILNeJdYBzv4sVmFpcMCIQ1H8abrPJnY+DcCLtp4Zz66EOCq9ddjK4qcag6uZbKxwmeBfFilBdBZADbPXIzehxw8TfUX73lW7ZRFOCLhDUTa12W8BGPqpiByFVimKGHcfdLzRMDCg4578vMYi9fatnNbi91IB2jr4JQINzpHXbEbT2/ADlCZWoT2+q3SLz5cfWCn0Yx3VioqoA/pY460X5Zvqb5NcEL4wgK61flIBCRC3osxdsOjVSHFnVlkXmN50jITWbekcf8woOL+SgLD+JMv98naeJJLQEJMHJpI3ck6AFjoV8tX7OPaiz+ERzck96PgcakWZnqD61N40m+/KW3HvmuZ0Aii1ftYhrXDWUXTcd9bxJRqjgPbKwo6sxTtmMDlfFp9n01HV43I4fOg4kq00E9s8vQNjppo4zfJAG4/GBpss+AdOOiXsteiqcUy3yLuVpBCqxzRLno+Lc7vbb6Pa5P57DemUFwqL/0HIBVZGnlM7ZArXnKB6pWNRtod5SXjYsOvHUfP7gEzwazqyFLY4iFsc8VQelxp6HFQ6ZKrgRUPKdw8jkPIveZGuAlJ1LcTNTXsRqFh
 rzyi4u6s
 i7piisDnD43QbIw6s7yhL0Yh6PejiL9LSwnNK3b5ZV55WnxtBtGsUofEo1dDp4fqIUa0TRrbOiFDeGTDIFWNRd+opQXBdD1jYiOxZnLa/dtu2lqN0J0RcESgmU9XxtC9he7A8CRjhD+psHnUGWtcSq9ZgPZzGx8vib+WIgtKFR99INtDvPGTzprZLTSP8AY+f+2H8qFB0MibOK8TRWrWv4jhDfJlFvpcgmJ4orwj152qWcYlA8oFrN/+YS2BJFt9wL+exaJckDD4AhcU3/6zU0OcANwjUniGAnEovamEOSUCb7vATuWEDHlm3pgfftbKrtMFHwbiPGe82Leph5xNfwmk7umvfYklGUEo8fZXB8Urwc+f1rq3Pv+LU5Txk5blVfLALjNF/jwjzn9iQMmu/OCufd+epiJ6fxFHJNu2wiYI5aAMuNR95i/j+j0PJA4ojc79R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 02:43:34PM +0100, Christian Brauner wrote:

> -static void filesystems_freeze_callback(struct super_block *sb, void *unused)
> +static void filesystems_freeze_callback(struct super_block *sb, void *bool_freeze_all)
>  {
> +	bool freeze_all = *(bool *)bool_freeze_all;
> +
>  	if (!sb->s_op->freeze_fs && !sb->s_op->freeze_super)
>  		return;
>  
> +	if (!freeze_all) {

Minor nitpick: do we even need a dereference here?  Just check
whether the argument is NULL and adjust the caller...

