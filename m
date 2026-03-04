Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D841CEB7EDD
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 12:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46F8D6B0089; Wed,  4 Mar 2026 07:32:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4024C6B008C; Wed,  4 Mar 2026 07:32:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31BAB6B0093; Wed,  4 Mar 2026 07:32:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15E986B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:32:47 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7CE031A0498
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:32:46 +0000 (UTC)
X-FDA: 84508319532.08.F4B3A3A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5C8F3C0008;
	Wed,  4 Mar 2026 12:32:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O5HZ9ZXC;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772627564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjCfca6iYc84dBPOjnnGboQQDM9Io0/ZLrvQJXyY+m4=;
	b=UP8wHRZ1H1pce/vWw15nSXs0dkGpuRuYbjFflFzJ1A3f2TpUafsVOtMUB3dAh7vIzoy0PY
	2hJQ9j6DIPGRul+r+s6kEyQhVqtNh2lTx4kxeCuLr/IU4cS9ByYA/bbRLvTBo1kgqyhFPy
	OEcQo9buhK5M9wOZH6inyNkWQ9frmLQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O5HZ9ZXC;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772627564; a=rsa-sha256;
	cv=none;
	b=MKV5Xp6R0EflDA/snkT/3PNCcIAkyPszFKhhZw6ESA4y2+o6T3d6e3vt8UMxbd7ECZgeck
	shG3kpM/B0mkEGOOuEpw875Z9T8zdqVfA++F1F6zUwCc4aSXdVXW3Paoh2qYcjFx7BYXTo
	1x6dpupr4ElxaoVo0tk1YuCkAhT/CEo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AB6CD60097;
	Wed,  4 Mar 2026 12:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC92C19423;
	Wed,  4 Mar 2026 12:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772627563;
	bh=e83BLM5GvLOSGz2uXBojTED9JFHiqSjMgXE8Lu25qK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O5HZ9ZXCJqHwto+K5TFar84RC/tF8oNzANWMk/pDTUv0yJW8zjeLJacXbuLVY3Xr1
	 9fkVHSKfuzVaATC6KcP4bJBtD8p7xm0HmEXyxf+kH/slGw+wp9sTxWhhWTjK4S2y90
	 C4ycuiLzzeab0IYT1W06GcB2c0bw/oaa5k3o7ZhXK1Ty7Vi48HNCNwwnfIM9Ywmner
	 mlqK0IhGLn6Ady683UiqkEk5BAzJ4r+nasY/agjsM9bTZVEBCFgsaiQula10UbtIJo
	 UVTGmS8PhJknVNsogbZWNgSsN9uPDBXfi8bl6orUalEer0ct1mZsEBEvrP2u+6VVmN
	 k7I44NAJRlW2w==
Date: Wed, 4 Mar 2026 13:32:37 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 0/32] fs: Move metadata bh tracking from address_space
Message-ID: <20260304-badeort-amtieren-d02d2e06f2c5@brauner>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5C8F3C0008
X-Stat-Signature: 56k6ihtfrdckit7pwqhbke81549kkbu6
X-Rspam-User: 
X-HE-Tag: 1772627564-912752
X-HE-Meta: U2FsdGVkX19xbi1GPYfF1JQWfFtj3/bloWqThWE7bsEFum0e84pHDF0RdOMSOdwHNKkQcW4uDvUAbg17mDUdTBBuz0h9WFiYLRhDqyrw8N1sNXDtYv323j7ViGg+g0aLhrenVJ0CduV5xGimw7uSajs4yCcp/wGyRHfoLvUcszdBBAOfsku1sATinKFql7k00DJ0U4NniWYI2CQEvoNuVIrrTLUvXrCYVNRm2W0k4TR4VCxCB5AWhPKRJbmpv21yunnZm4oy00R5M8nBwCz4PN6DBkDD287BtFU4MVWa9pXmWF6vd+k3mRrE1TvQtrc+Snn18sHz9qUFXqWujOEddZEWhGwskGMdBVXEt16tf5CCzUi2Rf/BYnhwKHd+Z9vLuHT0RlSTZnQQzRShNI+NGrN4q4tAJKjACzhmKhANhJyIfgx3OgBLyUy1tjr9cYCau6fyB5KoEE1IBWwtZeUkZ9dc4qOm0pCGqNFv94BUBeHwm8KLrNkyhcD9UlXGU7a4l+t9DlLA0nXN2wNCYz2i0xGe9tdOXG3sIA3JdsaAp5CjZJ72TIiPbjEaoa9XsqFebNT+WaWeW7HFEsp4ctXlrAcJC5arJDgrmXj50gPdYbMelNAC6PHQndC6p1s/tYRkZIkeiocIecy3VFAS4Dt+IqIk9wYTej2AvUQWkWuuzo5gz9w+z01pMK6/1AY+YMNIa5S068TBSjV8sB8Ky49iJgmIY/cOlYcYqyE2ONWv1CUlSc3tsd6YDXhgynQOpiQbFFvGEGDtGDBGrVq3H9LP+YflXAGUIpD2xbXmJzRyVqlrzG28IeBakT3FRCmdzZmqfE02yrdql3DH/FxnhjKoS6dZshg9x4WqXPufMq8X/1mgCp6Bfq6gtUz+wFZ9PWDKGDu7HDY+DLZPytcSufoLURefwe5r3knLJGmZoAo3VoQcZSdtCL8GBEWxP5cgDXOspP0iKGYNfrGUH8wVCrW
 H3OkF555
 x5TY2tKRzaaJCdsqdvpEDQUN2TdNxZKhCbOmr7SA8q6Sp90ZGswuBSeTBBRr79dmqzLljyPWfb+ZHjLarIEfWei1dDkjB3uOM41YvvXQOSaagy+bcjZHusgeqDYCMmlHQo7IeTWUOMyp4HR+ZPWihIx+tIbKookO8OB953j8AsVLKEqlQsBTHoJW3tnFzG4C5GD2xM4SAFsNH9QZmVAAZn+wbvoWPV58W8mddIiYklBRbDUWE6VTe4gheFvLrWjBmdL9FU5JJAW29iDgYasTmbjYog3huPeduiVSmSQJa53TAaYC59/QnqG9DtBlr/JqYrTSfbcGQxAhOabSMJH8y1TEyCY6EheitG3e9t3LCPh+7hwp+u9Nrqph+/KVICJjTvG18eFdPoISeCEOdBBdzshZnvBCDfbKI7Ya8WZ5aqCtwdFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:33:49AM +0100, Jan Kara wrote:
> Hello,
> 
> this patch series cleans up the mess that has accumulated over the years in
> metadata buffer_head tracking for inodes, moves the tracking into dedicated
> structure in filesystem-private part of the inode (so that we don't use
> private_list, private_data, and private_lock in struct address_space), and also
> moves couple other users of private_data and private_list so these are removed
> from struct address_space saving 3 longs in struct inode for 99% of inodes.  I

Yes! I love it.

