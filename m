Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD683CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 02:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266D4800FF; Mon, 27 Oct 2025 22:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21733800E4; Mon, 27 Oct 2025 22:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1543E800FF; Mon, 27 Oct 2025 22:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 038E9800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:31:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 921964874A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:31:32 +0000 (UTC)
X-FDA: 84045946824.13.17AADAA
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id EB2B3100003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:31:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Le8KjsBu;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761618691;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMWzOpxOLp7djj4rryockFPgtDMeGtwU0HcuCp9Qs50=;
	b=A9hSPatTifN/Zqy+ZgJAM0xDlvqzP47hHsaPU84jZ8/RqxxW52+Fg+YkALfRwS8g9ss+ap
	hqUnKoKlVRezj6l/VLhLmMQhW3zGHlTo7LSF/JDDVo62PrWMGox84NP2tDaFG/wJWaIETQ
	m2dYVywK+JedEP2+Fc+7IUDjV2cou5A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Le8KjsBu;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761618691; a=rsa-sha256;
	cv=none;
	b=v5s1oWJhQNyR7at8L/k6Mkqam5DcxEofh8oA538c/C0n27t5b79x5c202t5BhsZ8E70W7p
	ZK38by5rjjXsaEJqgG/c3qHGUjBE8hNb6oipsFqMG2O+tSJlsItVxDHa8jRkDHZs7HVJiG
	tKsbp3ZFTMpaRdiaOvhSBNGgRRe20p4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NMWzOpxOLp7djj4rryockFPgtDMeGtwU0HcuCp9Qs50=; b=Le8KjsBu+85kzt1t4BL8YLSUCP
	aF48vXMeS/zemSMpkY8HqTGBwm0ZU5YrRhYzEC5oZEVC+l3smpfNXn666wRG/uExh/x7oN9MB9XOj
	zpeS72wOY36FmbBVPzYMMCQUKinAbkmV3tCxRZIrNthIThSX5espx/xsim9TTv3BqSJ5A3D6OV7Yi
	rK1NreXBBAvHNZiQc7rChyFRYtgOIkKQZt1TysBJYZfVG3/4CyNNL7QgtACAKJ466GTZWdbgE7ac4
	BJAPN7UfUYSWmql2NJztc1/1b1yzIJ4W5eLGvarO+t66RFki8ovME3q7knigxC7p/U+4mPtzoxn5X
	iyn+VxuQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDYwD-000000039xT-37LE;
	Tue, 28 Oct 2025 01:55:53 +0000
Date: Tue, 28 Oct 2025 01:55:53 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org, paul@paul-moore.com,
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com, selinux@vger.kernel.org,
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Subject: Re: [PATCH v2 31/50] convert autofs
Message-ID: <20251028015553.GM2441659@ZenIV>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-32-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028004614.393374-32-viro@zeniv.linux.org.uk>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EB2B3100003
X-Stat-Signature: hzktnf835x4mt1ffhrj71xufeeu9iq44
X-Rspam-User: 
X-HE-Tag: 1761618690-805569
X-HE-Meta: U2FsdGVkX18Z27uFDbVphjskOXYVv0AQrKZmNbzfxlcDUlAdJUpVN1tuL1YFSXZAC9ogU5omNz1nTZbA886hiDz/Rao3kpdxWrM3rxfQaW+u7zbexnef37b56fuFJgiJe+GxAmPk5IqqkTYuQ1GOUC6ccisKUbt538wKGzN35XX3GOODqBy1+e1Ckl4BlZSIoX+upXzu2ZS4xS51e08/cpfCz3a8TEk9/uyzpbpS2vxVur/Ekvh3p/HGvGSNpzwKb2B/Aa0NUsqUtgam1YhFCcXxsuxHyMJVogqYBI3nZa+OPbx98/pbK2y8FgmXeYAWZChy0NAXlvluvDtMS+yC86EIwJygCXK7kUOGurd1ruLVmZa761Puv2KqBUDFzT3jFYBOnllWvrTeRctuLb/smqKzRaQiS12fSpmjBoD+rgJ7ICscEP/DUM3jqx38n620T4BH28p6JKP+ZlGZMj1ezvtuN22lRkqtoXj+L/AquH7dJaxcjlBBhytEBoY63YBP+DMm19NlWy6n9w9GD/2SxedbPm+EvQMMcPP6iIoQut+X3KRfb8MnHuWMdRdppF7dxDZ+j0tIle03OLvn0qjeT8z9//qVuSuzdQOdrsW+OzUeubGqXyRCFGdSHITQweySgF/WF8H3Btw6Rhd0Vf9aU3yigxD/jr2SpIa7wAV4VI831zcUAflpbh08KPhho4l8P11jsAwkuJwmx8HBETCquFagqZhHDqyx7rZR47zGnoX/eqpgpZQsaBoMfFDaqezwxoEEUgQQCDqj7Wt3fjIr1BJf3JygL+EsoVOlmmFhOVtr5EGE+zHehSDzU2O7/qxRkof/IZSyJDfiFuhjm5nqPOGUBlMhwizYZY8kzjZTjVSPgdG5UALtizlyqONYP2ZycdxJbcSgCr7Y/2ly2djMYf+sSVA3q2/y21tCFnsc46w+R21EW+E44LQeYbg5mNVqgyVQBu0oczrQ/ScJo4Z
 NnzqphwO
 KDXqmxecOlAsmqAJFM+XsPyZyNrrNL5LYh3HX3YU4PpXlCeOSPfdNr/kYWYJ8gDv+PfJvyNPlLGAm47YZ5VPZLiFRinlVQ/qsynJqoIw2k8FvSRbK9qUwnnXsFJYpHwu1VqIfmuRlUPmnwSDYjScLzNxbWLkaBfMM40HPvKj4PbVqQgDhpUoy0mFMI6942/FO33rL4S9cJXclpxY/O9UQdUxJK8jKEAmtBoaHhmszA/Ah3WWxb0NgotcSUuc9rrY6uvZRUWiV/MshiObwUSNG6Y47f5IzczK5IRe0HLjUfp0RxHIWdmjipduJNR9EKFs72i3/1XiRdJLcQCkktmwmXYjRgW2HtoBSPI1lK4mPqpgAzzDWY/d5i2hR2Xl14TprXNZCnCUGQXHPMp6Hy2E/gZ72hg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 12:45:50AM +0000, Al Viro wrote:

> @@ -627,7 +626,7 @@ static int autofs_dir_unlink(struct inode *dir, struct dentry *dentry)
>  
>  	p_ino = autofs_dentry_ino(dentry->d_parent);
>  	p_ino->count--;
> -	dput(dentry);
> +	d_make_discardable(dentry);
>  
>  	d_inode(dentry)->i_size = 0;
>  	clear_nlink(d_inode(dentry));

BTW, is there any reason why autofs_dir_unlink() does not update
ctime of the parent directory?  Try it on a normal filesystem:

; mkdir foo
; touch foo/bar
; stat --printf='%z\n' foo
2025-10-27 21:40:03.489427380 -0400
; rm foo/bar
; stat --printf='%z\n' foo
2025-10-27 21:40:16.853470607 -0400

and note the change of ctime of directory reported after removing
an entry in it.   All Unices since v7 had been that way...

Why does autofs unlink() need to be different in that respect?
Some userland reasons?

