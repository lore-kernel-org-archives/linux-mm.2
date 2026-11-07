Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7D57606D83E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 16:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q3lPZ/DM
Received: by kanga.kvack.org (Postfix)
	id C03B46B05B8; Sat,  7 Nov 2026 11:44:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDB1A6B05B9; Sat,  7 Nov 2026 11:44:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF0A16B05BA; Sat,  7 Nov 2026 11:44:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6986B05B8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:44:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B493120335
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:44:33 +0000 (UTC)
X-FDA: 85408896426.23.811D9A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 12A62120008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:44:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q3lPZ/DM";
	spf=pass (imf29.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794069871;
	b=NRZEa69JU4JmegHAEnpicFVUTutXKIpEENkLPLiq+ks+kJLWYSgBs54oXjroCYcEhbHDlp
	KLeHnxWK5XMUMixJ7tNg1YJv5r9mn1eR9nkHBKbnwT9yvXwhVo8tHcIQRWr2Z/HWXd8Coz
	sDDip7Uff7r7eKkyiQ7pvibb4qO11og=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q3lPZ/DM";
	spf=pass (imf29.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794069871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0TBUyhmKh6st027cPZY/A7ojV3HiUgM2XJr1Qt7yqs=;
	b=X32rTwrVnncR659vLvJf5LachyNDijw0dk/m8KHzdrNs4gzist+CJWLnN/wUj8hVR1i4ga
	n8OD0qLvwAWa2b4vpEGxZeD9vkV4PG+fHstdjweXlDxIq27vcnBAeHNJvs6SYKpUmUXSnE
	195ercYhtO4XJDsdPU9VTDLf00vqKR4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DA1660D15;
	Sat,  7 Nov 2026 16:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E619B1F008A4;
	Sat,  7 Nov 2026 16:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794069870;
	bh=G0TBUyhmKh6st027cPZY/A7ojV3HiUgM2XJr1Qt7yqs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Q3lPZ/DM6uQ6KxKqeMit86Uw4h24/Oj4MoAMD+U42UyqHSJq4m8RqVF8SFBtqbgkl
	 uLKz7uSZCEmnbuYs91ZPRuPISbz6KSUXhqlGhYcdFXvRs+fV4tNtz+fMJYc6LC8oMR
	 oFDFo+Teg8oUBRgmiYpBQfMzAA1XArB/oe6USeIIpMwY/xLRQ+GXugleq6FMCjsnvR
	 oL0GzjIOrGJ7szvoPIr8z2eQLBvFfcxaFY5OSG8DuQTl7sLA5iAPsPb9X1GVQmFWRl
	 v9+b0K+DLHBtV/h4SwZCCLNGLR2bk/lGk8/rlnYsXPGkRtp7eujxFA2FlH7COmPBxC
	 cINjf9/GH3c6w==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3FA84F40067;
	Sat,  7 Nov 2026 11:44:28 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Sat, 07 Nov 2026 11:44:28 -0500
X-ME-Sender: <xms:bFXvandvnO8fT9Ny0BCMkPPq4EFCNpni2vpykfELem4aQ_ooyMfLPQ>
    <xme:bFXvaoAzA2Ev766iXQhLHmbFgZ3OtIBo7SEoGueehftkt2V279uG4gPc-dHGVACl4
    3eUuL64evjIj3at6Odni9S14c19BTcr-N9PUxIQTqRuyqO5bQpFvwjH>
X-ME-Proxy-Cause: dmFkZTFFrV0pX7VIZHKjzx4tcEIBivmHNdZcL0Pkl1lJMTa+tHru5crcMzNJ3Ws5mFJzd2
    XoT9/tbpTRQi5ChHG+aO2WivfTQ8W/O4HZ8iiDaUhj+m1NpPL+KAn6GP/9UxfYRXNa7cOc
    joX0s1lnfj++o3vhXCB/o3bz0dxm7d2O02yAjwOawfYiOaHUVz/507CGSU2dlZJBdpa+Lz
    mT8nq07x/0R9yoox5e3apvL89qLOUo53VSUiLJOZQeHJ+y5wU8qmJSABIKtsK2dgt8sOGA
    T0DJ96+tszK/FKEJttYLQ0VT04nQzocHzMxQ4SOw7VSUIeN3vxtysUHCL040YGaqf23dGj
    ivvheSUM0dUu5CxVO2D3v9xKFwvw7gFiwnI6UZYJP+uiexSaebviQXnQh8wljTipWYfAFU
    IDtD+lRbDheFBrn7MsE10utxcQB7tzgbJi/CxporQ/0eC9ISB6TmNPCUWQW6EWtOUS1W/V
    EfIMfzoVkcdnKDH3f2go0raKAX0SZ+/rZLtKb8QoFwHn2sRk1lRwwIBewPwH60y5mUz1IA
    WNrlo2pYNCHcEWWJdaW35YV6jWZAX+iToSdrBmlEz3no1vvx1gGr28JIlz5xbU3YSZffVC
    XOYDs0bBCET+39NKG1Rl3ZxSLfa2WPKKz5qq4UxbERsnsGjG5/I8hnQr8ljA
X-ME-Proxy: <xmx:bFXvaiBZo0cONei-bs8Nn0XJuMfXZQKqSffOVJ8zNsNVaUiIUh4gog>
    <xmx:bFXvaj54dGXonsoLgi1ZS_BqxfhmI6DHm1oV66RilkelMocJVZZgbg>
    <xmx:bFXvahk0NuZcDB1AhZh9ACjM7Ufrv3Lvp0-YaZL6LBc10s6td6_Deg>
    <xmx:bFXvaqY5dGBTySVeOdGC2PKrnCR7w_fFScEZ0z0S-oALV8B19pi_ZA>
    <xmx:bFXvagqosWNpEErQ6k8RVnvtVK1EAxpNL3pHPEOnn-RYopUKyguaOx3_>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 12146782738; Sat,  7 Nov 2026 11:44:28 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: A37rHgw9iumg
Date: Sat, 07 Nov 2026 11:44:07 -0500
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
Message-Id: <a04dde49-8373-4687-a905-10c3a3b89492@app.fastmail.com>
In-Reply-To: <20261104-work-procfs-net-v2-8-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
 <20261104-work-procfs-net-v2-8-221e2437fed1@kernel.org>
Subject: Re: [PATCH RESEND v2 08/13] SUNRPC: let procfs copy out reads
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 12A62120008
X-Stat-Signature: hfyc3pokg38s3n1z6rhuz5tae6wyia3a
X-Rspam-User: 
X-HE-Tag: 1794069870-408938
X-HE-Meta: U2FsdGVkX19H+0qcORm4+kwZ17LO3vIOEA6qJsqyXDcQfPwhfjJ5i59AUOYtqfBYKIdhKldSMXJsIFQv95SSP7q1DC/b1BN3ek5S/6HH5dQ4JM280lcU9SAQhJJIBKIQwQJhPueAuxHPDwoSV4s/tL9lF9n9in0qBDAeZOQNgd3E95eESmrd/XmQxWykO7Jg0Zc+kb9n+6EaDQpw1cr0mwNdDBnurcxfqWol+nAsf2JYuEkFFgPqQlKTTfs9nljsYt/P4uG9vQ/XB0ptE6a7ZXt7GDxH1amAwgCXRVQdNxdNB6Gy4Pnoif2MNqotkZ+G0n1kzC45zfErolXT3+/xgfS28/3DHl93CPImKLFkdqydFapMmUVRxgdGCxsnipwxrYD0ZLdD2dtLLBskK+N9eMBd/1NQ5QxkdN7VWRMT9um+xODxMaiFzOsP/A+Y3Q9miiBputWRBWOWvifoVWLq3TQaoZPPUtXGag8/ntR41D1rK/JDF5zK3lB7qqh8eAM8JYUbd5NEP9gprZwquCoql/DqwJzyNK0HTusV7U58ctUyEZpjfe4W6Hyor/waW6lhuCYoI+PLVvUfxCBIYjd26zYwDtbcQWf+cqgxLUJaOTnZfQ9bTWJFDI/4XDq7QrNBi62JCyz7n9aOlwR6TlwtX4rDtcb/FD0+zltc/0pc4aipGsZ0RCUdNYJ2/WsEB9BizMwGJoiVV95HI9xP12B5uhHU6KEiAJ1DPOST3srWLxQBnlm4oP6hf6HWrZUx9QmdbtKzCYbHUc/YP7wWyaGWE5okfoGWAsgvHCS3p9eGToLXOSVOpsN6CLqp8+E1vZf3KqQerfInI1wiZ/9lXy4cYHGBlo2TTPuyKiEpIdky971Tq6n+DwU9Qmzm0YUIacSR6nmxnUebs3KBp8E6CnB81Pc7uSQ0aMX4+gOTGpqRcx2tTbbnJy+B5t3yJNfH27lPO8oCUlTj098XhOE4FyM
 GtgEdWLW
 rOQh6tiUw0wksbXjzE0mLHMR9huFq2Qr/OVxQmL6mdX0UYrw6QAQfzPGjpa+R5sS6N7RCjaT5b6Yo651PFxnz4zyarsezXhRzANtT5VzIE9nxEBiC8OetQJ9jW+TPnaCqjpET+r8z5ewE1OwG3QXyjUd1CnQiGO3kKWy7e4Lgj5lEVUKTL9KZju3xemGaCh60sX3vVAQk5XtAa28bnTVThonkTSCOO/3GbgwdHTQr6jZbnwPvh4TCKieHTiWmTT509gDqIX1SzQCvTqexaUE8vCexZ4Xvbz/cWL4v2GFGKXoGK/KLFEW+64oGjoF7g9uMuasJgW6Ryqq3Qz3pEtudtI4vjsdwcgf3G/rD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Wed, Nov 4, 2026, at 2:59 PM, Christian Brauner wrote:
> Implement ->proc_read_buf() for the procfs channel, flush,
> use-gss-proxy and gss_krb5_enctypes files so procfs copies what is read
> to userspace after it unpinned the entry.
>
> cache_read() takes an iov_iter now. The rpc_pipefs channel file passes
> one for the user buffer and behaves like before. The procfs one passes
> one for procfs' buffer, and a read still hands out at most one request.
> A reader of the procfs channel file whose copy out fails, a readv()
> with a bad later segment included, loses what was handed out, since the
> request moves on before procfs copies it out. If that was only part of
> a request the next read returns the rest of it. Both flush files share
> flush_time_text().
>
> The procfs files are removed when the network namespace goes away and
> that no longer waits for a reader that faults on its buffer.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

