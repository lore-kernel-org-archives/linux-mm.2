Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2EDED116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CF5E6B0098; Mon,  1 Dec 2025 12:48:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FC86B009E; Mon,  1 Dec 2025 12:48:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06EF86B009F; Mon,  1 Dec 2025 12:48:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9EA16B0098
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:48:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 98B22131DB1
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:48:46 +0000 (UTC)
X-FDA: 84171637452.25.166DEE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 553531C0009
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:48:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JxW+6ONT;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3/u5V2TuhJF6zMuw/qzx7YinSVb0V+ssXcG9t7IvMvw=;
	b=qfhhBueZtgOMXqH0g4zLcLr/EjerUYz2O9Wz4X+4sMIm+AgJjnbWU0fX+raKLUMuo0pt4H
	psd0OGdL+8LCA6tu6yJxMMWTjKJXphRfyJh6UlHSH4XLtU7UrE3qlUD6oppSVGgBcEvdWd
	BgX0KVbObZz0zbT/TFHdm0szAH/Xhxg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JxW+6ONT;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611324; a=rsa-sha256;
	cv=none;
	b=59+rKQ08GrNX5hx0rL9JNDvZ+bZ80W3Le/GINsuMEAwDe68TMsJotw2Xz0AK4rWLh+rwBe
	CIwgp0v4qxFO0VGTaQPyrwZIxNOu5qWh5rJUvSDKipXSNHFq4vOIazCEcBRevdSo7/jLYm
	cQ78yMhxgCcxxvh6vbBUXdBx291MGXY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5ACA044412;
	Mon,  1 Dec 2025 17:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DA3C116C6;
	Mon,  1 Dec 2025 17:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764611323;
	bh=hWOrPGrXp0FSreB+cLgKfrOmVZjwbI7HL6KWRWP8naI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JxW+6ONTFdkKnH8qRt+V/a6Lqis5xf83eDQ/0gsSHu8BCvTuuW5ml9eAr9YdPcNO/
	 9HEriRPkCoNBOIWasS33PicthSiEVGxZhmUdEb4VTMSMF+lx5Iw8VbGaVNRpLGckuK
	 CvXF5irlHnvVUwfil/E/3uzW8Wgxv8l1g8CoNKPhxmoqK2g/FnJgN2a27mDUrQe2dI
	 fz4vsmGb7MJQ1WMXo4cpnehoCvj/FgOd14h0QR9fkXsQOaAF9uuo7IkTMRBDqtCELH
	 UAzCLs8HyXNhBAN+JiRhQ9W1cWORT5cpi/VmzpzxdOnXdnIZ3FcSC9afOMsE4WzUVt
	 nY/nKaioEssng==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id BAA69F4007B;
	Mon,  1 Dec 2025 12:48:41 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 01 Dec 2025 12:48:41 -0500
X-ME-Sender: <xms:-dQtaU4oaaqORes3Wm3ewfhpLTMHvtSCYqOzgYHmuWJH7gFIV7ig5g>
    <xme:-dQtaTbtswQ-VCP_VypdQYNj5_QuX8_NEUqTZj3ecGemvwfFwcwSY2JzySE537BEV
    LoI9D7uS2gaIigltPdpa2ZWHyfdngib9UZtBvzWvLQt6AEQR5V4Wao>
X-ME-Received: <xmr:-dQtafiZ9zMvQUsY5sugRHb2gKkM_dHTrM5Tj5eU3JHOvhZ7E5AK5FZEL8GJlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvheekfeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehprhhsrghmphgrthesrghmugdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmh
    eskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdgtohgtoheslhhishhtshdr
    lhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthht
    oheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepthhglhigsehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepmhhinhhgohes
    rhgvughhrghtrdgtohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggv
X-ME-Proxy: <xmx:-dQtaWZG0jMyLySHMMbquwP107dJMVh7GL-0giiYvJyFgdQO9A0VPQ>
    <xmx:-dQtaaoeqfFdK-zdshvCMSurc5WwgT-gmr58MMcHfABFpSMfNd3LKA>
    <xmx:-dQtaWSF5tQKpTbvq9yQF1JRwV2nJC88cOEb76sUIlXqu2_rPmPnNQ>
    <xmx:-dQtaWk1Z0EjDWP5Qnk1z4D6uf6BceDXkTfsAebjxNg6sw5ixnpxvg>
    <xmx:-dQtaSHg4a8nzvU5LDRMxwuicq463OnYfEB8iIshMyfNSvJIAMmxOruh>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Dec 2025 12:48:41 -0500 (EST)
Date: Mon, 1 Dec 2025 17:48:39 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org, 
	akpm@linux-foundation.org, david@redhat.com, osalvador@suse.de, thomas.lendacky@amd.com, 
	michael.roth@amd.com
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
Message-ID: <maleev6ofzlnhi3rmqjawlllxkda4mrgwmb6msz5gz77klfrxl@adpqtakqrxrj>
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
 <14df1d99-7df0-4982-8029-e66dfb140399@amd.com>
 <dy65eupwalp5wsljetlto27l6tjjvoygeotjd3n7mk7zjc4dma@jf4hzsy6rtcd>
 <f60d968e-6be3-4bad-8bf4-8500ad039817@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f60d968e-6be3-4bad-8bf4-8500ad039817@amd.com>
X-Rspamd-Queue-Id: 553531C0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rt1doys6o1dpz58onqrhu8xedq44orpf
X-HE-Tag: 1764611324-7249
X-HE-Meta: U2FsdGVkX1/PELCGSkX0rC/d+9hxYVux2gzHi9aHOs826PSN5GjlqA3gtewRT1DSM4fy0trcJZeUup+qW5zx1fp4A0IwaBOfG/JLDi4JJ5GVd9siMkQYODUdbxp+qiv6pw33gsbcraz0JuzB9Uf66i+kcftqAM+PPSQFWKRCRweMA/XeF4tL+3elEE11nx+0wBI0OcoG48nI4SswPwekHb9/f+ZoptYd5HCAYe2bIEU4/257fDQ1JhyjH9fljxFoaw5QiS3dFamxZj8kJ8ilykPcIv45SOJZ6+XZfqci2ahXQ7aBp6ESQF5DksGGp2J/U7Ae4UsFD8Z1t5ff7tMT9k7gxv89BbIUJttMFe0+cLiNF9l29ogYpm8tTnSa/c9uJnd2QcL3v+fixnyGo6owf1JNQgw5zJORrGEgY8eiW7y9lMQ/Qz+qz6VEZSTiOrDZH1QpMT9ACs0Ua3BjkQDYg1iOldZnLXnd3dAwHDre0NxhO2Oc4BgejHgpW/4jRTnl5ckNGGLcldAvpRUfyUci8Yfyq8+zvNPtYMuAhD784vy0FYaVp+Yq6KHcaT49HmIioc+Lg0SpPuBndnysjel45Nyh7vJY3Ylqssyp21giekC4+3eWv1ZvZ+KcsvJIcqTWLNfQoSZXYjG5YPKrWBJ/yyWnCQOihmAXS7hqYy5ELJDualS1b7DKGyIzlFEXAoxlw0kcXfLIroaRXORbDeTfbumgoQhp7OmRjAE8HWk1WGm1yOb+482Hl8kKhC2u+QJos8FP5CAKahV41NgU2FMJTtqhe9l8fktM+2K6Lo6V5NBjD8fsIE6XxJk4N4WIy1KbRe8Fo9yqXJ1KLh6GvC4IfLnqoSVj8AiF6cSBB/YsDxcRohFkfyXyYc53sdS02idUbpnCwl0rdiO5d/NThoSeOrsGqY0/esHC0MdOqXnz1RNQmKBOkB35j4rRFi2bUV7YOsrFyqTSSu9DF/7UefR
 h4NSCY+p
 8722QsyOBofb2jwCDIdq79jXEiG1ep0EQnkePvwnJh9UpiyARxnFkvMi4XdJD5ykPBIgBa+l1pS6GvAXrRrUkQzv7Rz50ClxT7VTAbK3cQ7k9WWQ5gMEPyT8nlyUaOfYa/3MNiYJUGQ+uUCftO4gjzgHSBpiPl8j6qIiGus+OSjHsHdjpsyI9wyBWw+jG5O8OxRH32BGba6l6jVAyQfbqZcVvzrtbLL3DdrqAx/Xmq5n2LKciiBHYxzYnrASh0KP5rOVH1pYFw0s/1CEWT0SQmF79xw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01, 2025 at 11:15:13AM -0600, Pratik R. Sampat wrote:
> 
> 
> On 11/27/25 11:40 AM, Kiryl Shutsemau wrote:
> > On Wed, Nov 26, 2025 at 04:27:29PM -0600, Pratik R. Sampat wrote:
> >>
> >>
> >> On 11/26/25 5:12 AM, Kiryl Shutsemau wrote:
> >>> On Tue, Nov 25, 2025 at 11:57:51AM -0600, Pratik R. Sampat wrote:
> >>>> The unaccepted memory structure currently only supports accepting memory
> >>>> present at boot time. The unaccepted table uses a fixed-size bitmap
> >>>> reserved in memblock based on the initial memory layout, preventing
> >>>> dynamic addition of memory ranges after boot. This causes guest
> >>>> termination when memory is hot-added in a secure virtual machine due to
> >>>> accessing pages that have not transitioned to private before use.
> >>>
> >>> How does the hot-pluggable memory look in EFI memory map? I thought
> >>> hot-pluggable ranges suppose to be declared thare. The cleanest solution
> >>> would be to have hot-pluggable and unaccepted indicated in EFI memory,
> >>> so we can size bitmap accordingly upfront.
> >>>
> >>
> >> I'm not quite sure if I fully understand. Do you mean to refer to the
> >> EFI_MEMORY_HOT_PLUGGABLE attribute that is used for cold plugged boot
> >> memory? If so, wouldn't it still be desirable to increase the size of
> >> the bitmap to what was marked as hotpluggable initially?
> > 
> > I just don't understand how hotpluggable memory presented in EFI memory
> > map in presence of unaccepted memory. If not-yet-plugged memory marked
> > as unaccepted we can preallocate bitmap upfront and make unaccepted
> > memory transparent wrt hotplug.
> 
> If memory that hasn't been plugged yet never gets plugged in or is only
> partially plugged in, wouldn't we be wasting space by preallocating
> the bitmap upfront? Or would that not be a concern in favor of
> transparency?

4k per 64GiB of physical address space should be low enough to ignore, no?

We can look into optimizing it out when it is an actual, not imaginary
problem.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

