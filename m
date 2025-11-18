Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD8F9CEBF9C
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 02:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F8068E000A; Mon, 17 Nov 2025 21:35:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A82C8E0002; Mon, 17 Nov 2025 21:35:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 296518E000A; Mon, 17 Nov 2025 21:35:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1535E8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:35:41 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A016014034D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:35:40 +0000 (UTC)
X-FDA: 84122162040.18.3E3E5F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id EE0D4140004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:35:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=vgY5WW8B;
	spf=pass (imf26.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763433339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mksiD0j4efL/l3qMIIvv+bNsIVNXPI3dkLiI+5z/Yfg=;
	b=1oecWqpVCSb2nsugXM0vol2hP/ygjR1gV3MNftK9UBH1UGdSKqD3x/ea8l+KmEte1nYBp4
	YlvL+5PP12ijROXMmtAF3vhP3xYj/0eOEOAcqWyGu+ULfXcEj2u9Nn4EVn3ujK13VQ8vQy
	vkVSxY9rC/UEIwhzsKIWLk3JGdP8tQQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763433339; a=rsa-sha256;
	cv=none;
	b=AYMxuibXZKYG5ZpSBc9LIBwh8URSsvykeoQs/rZJ1P46GziAPhLL+9kf3QRSDbyeaQTftr
	fbWIiqpLFNTw1O689aoOg5ypaeCJImTpwBLyr72JrhgNp9PiVI5/DdBgWPVRtBMbiyVW/8
	8bJGhlTvboA5vBaskm4HDv8+FxGpU7g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=vgY5WW8B;
	spf=pass (imf26.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F1BAB601BC;
	Tue, 18 Nov 2025 02:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0235C2BC87;
	Tue, 18 Nov 2025 02:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763433337;
	bh=CRCD2rguqh+WPne9dd5lj9Micj6TMBS9/fhz6RbrIgk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vgY5WW8BnNwTFkr1CqGzVVAn8dfzoBhj2Ep9OZzZPeg1xHu6mF1vh8NeQ5gnPaCUI
	 hehogcf50XcUOoYsd7JVzTDcRwav8kb7J9bp0D7+WA2rBQFS9kfIV8oVTYMHRK1dX3
	 oaScTMoGOaQPuIDGSoELlIlMUyEt/lZG+FvX81p4=
Date: Mon, 17 Nov 2025 21:35:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: bot+bpf-ci@kernel.org, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
	daniel@iogearbox.net, martin.lau@kernel.org, eddyz87@gmail.com,
	yonghong.song@linux.dev, ihor.solodrai@linux.dev,
	Chris Mason <clm@meta.com>
Subject: Re: [functionfs] mainline UAF (was Re: [PATCH v3 36/50] functionfs:
 switch to simple_remove_by_name())
Message-ID: <2025111717-showgirl-suspend-2f8d@gregkh>
References: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
 <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
 <20251111092244.GS2441659@ZenIV>
 <e6b90909-fdd7-4c4d-b96e-df27ea9f39c4@meta.com>
 <20251113092636.GX2441659@ZenIV>
 <2025111316-cornfield-sphinx-ba89@gregkh>
 <20251114074614.GY2441659@ZenIV>
 <2025111555-spoon-backslid-8d1f@gregkh>
 <20251117220415.GB2441659@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117220415.GB2441659@ZenIV>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EE0D4140004
X-Stat-Signature: i79a5qgoyq9r989qfnx8z31pu1g9db39
X-Rspam-User: 
X-HE-Tag: 1763433338-166387
X-HE-Meta: U2FsdGVkX1+R2uQDRf6uJ7jmBImWD0CRvdHhbykkbn3xGIcvJiEkvMAjKi7i9r6D42wHARzDgfu+ktn1V6eMmyxqmdkooCijAdZ91bQwJqgonMscvVtK+flv+TIEq/JsaC7vMsPP4VUq5hsMpMPNNw2Xlm6XF8gqPsDVzi5SWenhvt+lAO5ghr5evNAyLjDXdbIMxgX9AbrDNKCDPPXqhiBCmJ9LHBfcnc5o0/9+Aw76NjgGg9pMIRdv3GClHuCJDm2YQdIb//eOzJ7ZNiehZkkZ4KBR9SrwYn7RH8vIUaJ4bgw+hgJ8dhURzUZF0f5wSXFn5HpqOuyJe9iE/9vzgoXeOOJSTdNOvMlXTHEY2HYEZlnlnKfZVKwGGINBycpy5krla+BNfU4b3lTrMHSXIhdNTOlxmkbTVnl3RSUA82ILYKsEeni7fLvcUAxU6ohQHzRcBOc9i21ZO7sCuPUnh3b8ALnHXdugyeu4UOJI3Pxkf8gifCIS63xoBMVUlnQP8EQURVGuoTLputPFJHHPBhpaCLP8ppBWy6THxxSXESd1Ihal5/vZeN7Jpge4lW0whlYqXR8D+ueKYYZAYrJxRqIKwtbgiR7m/rOAAgcNZWuJ2pEH/zSo2/j+oUrupYcSxb6b41rxuX2OTDbg1Briuog6DaImkCRLDgQQqRqhDwHb55MWVIka+g5Gi6v2696nnBVuJAp9Y1XFiL5SrmRgPVL3h5JyF0Cx9GdRG1Jb8FpvjXOLdKD9dfw3iKvpGmh8RubpzbJYdig/2Yr6lykV8HFw6r7JvmfOCIrIBn3kfVg+TjHsgx+ENDj2YjS9QzzwWL0QbbrCOOISoI5h6wmiEwu7cn11Jww6PsB1vAnf1IXyy+4Bl32YxecINwW/v/66z4Dm2jPIvkIQ5ez6seNJ86hnkNdCLaZqJPMEEdaHI1hqhPVdKGGjqe7Ta1KVOT9LdxzQE2ujdzlSfaX5ws8
 kP3bD/t1
 pKemkrAcNc2ga7vHmt95i/RVUFxERmA6Wciw9hrdzwriRy/eoPOsY3dhzLBCy/IVm5bJZ9DMuv1vRKjqcA6bmunk8snscsspojAztLhmaxdJLXZTIhfvMjI3Rt2ijWKq1/fM+OTyf2k6NljhpgrodINp4xezmsILukKIPYykBCBgpbBmnUuoln+VAeekNhsqanpec1EdHUR0s1pzbh/c2rNEq6Ho+rhM8q7Jet7W7ccRvaZf//9SL6u9+3n+Zj/wyZTk9KoAk6rp0D+ch6BvofQsNnRycKJ3gOexeqbIZfRiCqG0RC3l7knMQXPfASlz7U6I84Cw9YtiVZxxnQW+/6trr/7JcKsuhOtqYiE73GdTkyyclsrqRJfYvvBABzePjUgZutdrje41Nsiv4yffG+PiVFLxiPUiQFAWt0dm4Pvz0W9HpG+/uHHgQQGr8ezUyrt8zjJC/mBSf2ExTwmupZBxfwIL2hiDc9CsDCIVlL6ZnRZC5psCm8R+p8Q9U6tH6BfnF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 10:04:15PM +0000, Al Viro wrote:
> On Sat, Nov 15, 2025 at 08:21:34AM -0500, Greg Kroah-Hartman wrote:
> 
> > Ugh, messy.  But yes, this does look better, thanks for that.  Want me
> > to take it through the USB tree, or will you take it through one of
> > yours? (I don't remember what started this thread...)
> 
> See #work.functionfs in my tree - that patch carved up + fix for UAF
> on uncancelled scheduled work.  Individual patches in followups.
> If you have problems with that series, please say so.  Otherwise
> I'm merging it with #work.persistence (with #36 in there updated as
> posted)...

All looks good to me, thanks!

If it matters:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

