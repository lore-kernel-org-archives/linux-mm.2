Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2AC606A336
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 21:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e2OLFE46
Received: by kanga.kvack.org (Postfix)
	id D6FF46B05B5; Mon,  2 Nov 2026 16:14:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1FCA6B05B6; Mon,  2 Nov 2026 16:14:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0FB76B05B7; Mon,  2 Nov 2026 16:14:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 908C86B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:14:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83A1E140241
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:14:38 +0000 (UTC)
X-FDA: 85391433036.19.8EA8A0E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8D492C0009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:14:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2OLFE46;
	spf=pass (imf22.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793654076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e/MGsEabL/7GG396Jx8SjaCfwMIwyJ2tMCUpq+3DLDI=;
	b=orGSUzgiU0xAxKcau6YOJcppWybpzgx4N3xIpjSd/JTZBQNKJ1RT7wUb4Vh9ZMqzLi/zzs
	R+PwUC4mNria8couHzxb4pLjo2+Hvef2VGEve1DBc61O/3WP7svws2TidwUfaA/yEQ6+7h
	C4pJBszbPfFH3Lf31CmEi9Z9Imv7pCA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793654076;
	b=hWvmQ152d0kLIy7bN1NtduuG+ibxYAkGNRLl+3rTKvlsiX7UtSrVYIWspZHB6m8hGE8xAV
	376XpMC/9POQ+lKM3MXp7JxUaMXN+KVwpG/36czt95b2QCi5qQJ6YGLjKNJJZM1yvJvTAU
	ATs3+Ov5MRKLzF3eeHg6xv+vpteOS50=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2OLFE46;
	spf=pass (imf22.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07BF4601FA;
	Mon,  2 Nov 2026 21:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FFF1F00A1F;
	Mon,  2 Nov 2026 21:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793654075;
	bh=e/MGsEabL/7GG396Jx8SjaCfwMIwyJ2tMCUpq+3DLDI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=e2OLFE46TWKu5xklyz12ylfAApWKZbuHBOHbJd4znhtERP8z6pMgTnOEkR0yCqqrf
	 X0ZpIxeRlmWvAmyQE1zfgNegRkiz/UubbxC458xD4vJxAxkhweyZ+HBxeRFiQik0hK
	 +wEkAFlMdFp9HsCjiJFPZbKeeOwmN0SnZ5aHmLjB22Z3BdJ0oGBndBu3mtUx6S5oE/
	 tIdpACOgd6ZR4AXos/A2m04KYmJFV8XvlO+eyAdHJnBloO1fr3KqE20ddvUwAJAsQ0
	 ou2kTaLAFJf8XG/NKph8fFPzcavx2664UTYz2c3HH020DXXlEBK2jAFQFfsL593flq
	 hlsd3atef5CFA==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 26958F4006B;
	Mon,  2 Nov 2026 16:14:34 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 02 Nov 2026 16:14:34 -0500
X-ME-Sender: <xms:Ov3oaudaRP85NzNgvo9gkP-MXfbogSw56-7TMRTbPKxIonQDu3IxHQ>
    <xme:Ov3oajASSRT1bTVfE6Yfylz-Q2cb5WzhItUIpzyOnYi4Ho9AOkdZT6HjOaX20rb4D
    9taQ97lq5DfA_nhyUWeMZ_W1taGbwO-fS7RiMfZ9u2zRLst3-ycp9NX>
X-ME-Proxy-Cause: dmFkZTEwFlNdOZMJt/6ERsMJpfliFwApaNUQtGyzrNgUVhL+xr6t4hflHpnCpvlDcd34OL
    tsnnvmlp46QcBNUANprPsj0jIeIkFlAHqmtQZLa2Sf8hNpQ9wBRFf1oo7j5UmVKMmxUPoD
    CAYsZ+irDyVCdEsc2qGBd+J6vgHB5jfhOit/H7yfEU9O3BgxuDkP6BIpzFQICmtidThPiQ
    wQ5iTjbCuW/m/r0nOijWyl7wYDNa5di+BmhLTsIvAVvDZmQjQEiKQbgS7OaGcQ8IrAe2iJ
    dzOrAPUicjvABQdhm6+s8X7yR3H/OnFcIOzSI3sa7nr++6wlo9Nr7XGUu9npauH3EjdnZB
    d8SiICjs57Bl5kCrWEBHfpiNyDf0VcOFdp1B4zP1lS/QTex+fDbly0ZmI6Oy2ConL4lGxh
    /glhXDiohYMGBeqhE1OFWto0WwZtKmCLBCeSZfL9MCPfURDGaHHisnCZY6kvsOFDvhaCor
    VZqgtiO/SBK/Y5QgrCdW3HFV3LwJ8YmbXP/DugUPUadgGyQm7Xhur0+oUAzHb6By+3knGi
    7OFiG2suqU+MsawnGTt3KtMcmomuas+uDRlvRDytGDwdPSUnJzYsk2KECbsMV0y2fBTHk5
    K+qTiHGAHJZkj+8vu51m+NPaw7fmZCNvqOYyO7NAnNI1SzeRX6rDMtnriOEQ
X-ME-Proxy: <xmx:Ov3oajAjXaAo0MCg-5mOh1kpmlpYdD2YfnidScMjdG05laxXGCBcug>
    <xmx:Ov3oavbaygWZIZ9DvVH6jb71mOGY1Ado5jGzZJVcQaL4VUVNzfnyLQ>
    <xmx:Ov3oahBfqIJHdV5qBhjnVnio35nQ6hlhJrYFiJZOCEftQWgDSSVQhQ>
    <xmx:Ov3oam6fLaNBtJqW2gtTD_ISnxMIg_eBjR3o4IKYsrM5dijacJsK8g>
    <xmx:Ov3oaokDgUdqdaNtT5fJJp84D48qBuDsZWPWAns4MbOuSRRfIzDAfjj->
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E5D1F78273B; Mon,  2 Nov 2026 16:14:33 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AnCeav_jaY2o
Date: Mon, 02 Nov 2026 16:14:13 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "Christian Brauner" <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Jann Horn" <jannh@google.com>, "Josef Bacik" <josef@toxicpanda.com>,
 "Chris Mason" <mason@kernel.org>, "Jeff Layton" <jlayton@kernel.org>,
 NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>,
 "Thomas Gleixner" <tglx@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Jonathan Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>,
 "Greg Kroah-Hartman" <gregkh@suse.de>,
 "Joel Granados" <joel.granados@kernel.org>, "Kees Cook" <kees@kernel.org>,
 "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>,
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-s390@vger.kernel.org,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org,
 "Linuxppc Dev" <linuxppc-dev@lists.ozlabs.org>, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org,
 coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net,
 jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org,
 linux-sh@vger.kernel.org, linux-usb@vger.kernel.org,
 samba-technical@lists.samba.org, sparclinux@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
 "Takashi Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org
Message-Id: <f29a6aca-edda-465d-b6ab-9c7a5d7cddad@app.fastmail.com>
In-Reply-To: <20261102-work-procfs-fs-v1-5-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
 <20261102-work-procfs-fs-v1-5-d09a996317b3@kernel.org>
Subject: Re: [PATCH RFC 05/27] nfsd: factor out setting up the exports seq_file
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gs9hek8mhus75ai7n154h8feuxsfdpeb
X-Rspamd-Queue-Id: 8D492C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793654076-846012
X-HE-Meta: U2FsdGVkX18qrMgeqTPd5IOZm0MOzexdNi1TZB0Bg6lQ0fSewKVPBtX8nNqfw9l3nDqYu+5q7gTeNhudQSzNmkxnd71nCtgf5DZ/8k1eqOB3bG2YPK4bHZ7g2LECUoinh1vJvSnzK5CyKdIPImV9NR2E2cjjTZgZr+JG8azz4E+i8SytF4GAjNNwxEtxeP4B6j6OARWj0MhDJMg+4hX0DUSzLzpHAdLcv3RnIB1L0qCwlBp5U7vcawEugaBcXsppA3Ndp1IR3EC4TdPdU/GAdHuFcfZXJ+LZF3Y3YWyU2ewyy6a65p/2aXEB21W4Wi2jxKx6n7rrbbISLOP5gB0z2r0vhE4rRDNvWOjMtQOsJMOWVxKxlNyiQS/iGGj6pqBa8fHGWYUfgMpuVNhqIOSEXLRwVRE1sdG6fsl2rfj9rHCQAUYm1bSvpNYcLyRCxOHQsEBiBjG3TF6AiB7/nEUgv7j6sHT7Ntp6FE3sxPbR8UfirKYG+YV2+kUWck+3VqX3uL1QGU4gs/OIO3/qUKfwDM+dFCa6uy8iqGeydkAzSRWGlPrf6j4udKRzjflD28dJ7JZtn2Ug/5Q16WVr7PFSc8oLL246YyJXTESIVWu/8kVE8u6SrfMu6NYVufDReGVVBMlkA2HqKvTvWFhJ1DAZnXpQTM0H3J2ITdr0JJtV7FmOqdwR3INv+S6og8JKvktpFRgGRErRZG5GgDdUdZj8jarfcZ3RwQFSXKhw+lMyF9S2SwWb7rvGcXNDuuYgxlUStc9SQrxA9YA8FJbTir++vzO5AUQ4iO9R17oyYSF9j7E3SM8H0aCZAv1Yeguvfsm/EK2dMYdjm4EbhpTdsR7HJCNBofFEBY8pt2rn4gYq/goh6Gs0A+am1TJscl02ZRzo/IpuerLGce256GOmi0WEqeT0p91HjdBgEK8lBVT74IPFoq0pLjBmqyP+4gga1Kd9uowwoXS/BzbQwCw+hIm
 Rc/NdwXm
 Q/tnP+I0LHboZ2SVwAOu8uvyjsVSROeGimY6f2qJFmahNfX3JvbuicHRLJdjk3JkuNa7IBx1HfxZgBodlllIW8oYwKSUgv9RdDKgMC8EJIP6kbHWLZ3rOZeOIWxJ4NX3j6lTJxSF3ERESWe/ae8vVi04RWrrEeLWaqhk18ZofoN0u2vGfKGPkiDk4WLy/Wy5yJ05PLWNBrk33zfQpFIp9sDcat4GqACSy//zeo2nHnsdl1iOFnAEGreoq5GeOtg5mjrW8O+bJb8m/50xHBREy8XNnYQZ2Oohy+gBEbNbiJVdt9gV0Sq32SCZX0PtRz+S3EYI7RqcUVgRmFEdAt8cv1WQp12pCXdahypl8tvgHkIxopFKptNBtBQbJI3KA/A1K1LDEYPr11a84zjQ7SMBe1AnM9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Mon, Nov 2, 2026, at 10:07 AM, Christian Brauner wrote:
> Move setting up ->private and taking the reference to the network
> namespace into exports_net_init() and dropping it into
> exports_net_put(). The procfs file needs them without the seq_open()
> and seq_release() around them.
>
> No functional changes.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>

-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

