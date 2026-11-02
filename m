Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B66606A332
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 21:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dytOCAJ8
Received: by kanga.kvack.org (Postfix)
	id 9C15D6B00EF; Mon,  2 Nov 2026 16:11:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94A2C6B05B1; Mon,  2 Nov 2026 16:11:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDD26B05B2; Mon,  2 Nov 2026 16:11:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D31B6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:11:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C06F41A022E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:11:49 +0000 (UTC)
X-FDA: 85391425938.09.BAF350F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A98E3140005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:11:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dytOCAJ8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793653907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxWoHxsw4VPFqHPAqACZbusTmTkHUnFSnkXXJwnJ4WA=;
	b=LK5Tdqout68cTLKr7n1ahZbEg11jjrNgDh914Vn526ywmWbjy1wwHcMuBzlyapo6T/ztbh
	P/aa063jwraB/ArqINBNyy8uAKdUUME/TNFMTgs7AWUbFzED9DFs1Wdp3LkQX7EyJ8BtwI
	mWkSV2X6NXJYsbJMcNDjVkMyLYMxxgk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dytOCAJ8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793653907;
	b=FhY+SQl9hRB24wPtc1l9HvCBiXWw7brmEIsm8Jl0Rh9pR8wiMcNPf/GmFlho/8JVxaxIpz
	A7+dKMhrRqlvzv6FHpA4zLrE/6eX8e3llQtcY0mB4Xthfym1RZeKJvSmvRxBWKeRNED5b+
	NVG0V+MfPxHdWd6qDxFHbPU2JonASmY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A7F743D60;
	Mon,  2 Nov 2026 21:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC731F00A18;
	Mon,  2 Nov 2026 21:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793653906;
	bh=xxWoHxsw4VPFqHPAqACZbusTmTkHUnFSnkXXJwnJ4WA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=dytOCAJ80VHiZ1OuHgOm2U1eYLbIsfTF1vQWmQotjAlcYPh3GK76v2x+nXUxkSisM
	 rRSMnxpBhgTKN8qPsqtbMHMR1UcE5DT4mgUuhKJo4qXktvA3N/yVCLaVhqZ4M63hYH
	 QbrscRO/3j+WrNfWqflniFd2/f4mJsHcE8FZW7CXPExB2Ibn6fo+J7vdNxA+QmucPj
	 asTGnwJy3cojByhQ2o4smk8bCPPjZkdrGQJDXaJrz2GO4vpMh3YJ9pqlDgFCK3Aw3b
	 4wFppyIBa3dGdCapF7WeNSk1Sr3UoL9HoLlYvJGsRNCyDrMBD3ag/9W+/du91VH57q
	 5GRjihOJRtTyA==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id A6FA8F4006B;
	Mon,  2 Nov 2026 16:11:44 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 02 Nov 2026 16:11:44 -0500
X-ME-Sender: <xms:kPzoaoxuxxTdjPhQc-3C1zahFZ9aLPvFlowSXGC4R9C8GitGRfcHEQ>
    <xme:kPzoanGt2jIbLsy47fOpg3WSZ6PY5cBPEClcODOsbon89QNyNk_IgDaAKQadQr2gv
    uVji238fOMsmLse7Ab600gs9JzJ4DZGzIXqA8TonRFGYfmnT8t3fbcj>
X-ME-Proxy-Cause: dmFkZTE7nCOuYmDhbapfq9wnjcJo8I33hiQgEa8gG2mpUd6SiuGVjxefYxNF6ts7apvhL2
    O5TBTvvYo35j+hcPabsgTVdffpGt9MvK5vyw0ZMRJyC2vP2RybIncEIE31yiniEOHW+BGf
    KJmARPQ+h8rxdMmbqHuWCrc+Rw3W1Pf0ttMp3mPjsGk8H3PuZMLxakWBNCayAXhn4arSzS
    SZT0vmmbKnAjrINdR7jALY8t/GQLDesfw1v5pO7HM0aidEkcoMk/IX3mKuG96bBGSC44od
    6j/8Jj2EeiKpBxuZiOuoARjnD/H7MmHLm4946WLbdldIeKehhGb+AjzJw7psiDGcN84+AT
    fxd1ztnRd84WKFx7SmijybVrXSJKl1AR6Etu7r8JTz1E2IGG2rbVvLkvpR2IBVnXEcQUHC
    r3GDkPNpHJrO1FrRX5A6DIGX8s2wqnE6WbRRhP/2UYux7WzU3qFcGt1leEKU+a12CXazx+
    obllJ0NCoPjY5PVFTCgHM6NA+K8OAWAC3Y3QpVQ0GtrFfYBqHxRpcYNa889BVVJkMXM0Xx
    NfAqx7SCTsESPLk/r6Zjs10FtyBDV2ONG987Ot6HPmAwX9PryQz/c+/GTZobKPftcCgNbF
    dMjgQuUNaOpeJy2SLb+WxTNiYQx6H//DcXk9Eak51jjRY6pefZcEU0xUdZXw
X-ME-Proxy: <xmx:kPzoakX1575s1xPK_eRnHKHwfrJs0dh41R1DNgFe6QjSA1GNvloQig>
    <xmx:kPzoaucrAaHqLBPd5fXUJKW90uwtgM36P2rOCnTrC3gEediQhDxGvg>
    <xmx:kPzoaq1brQHn036GXHRWgb2TJPEUtB4n80avLnuqxkDWgbKvmiH79A>
    <xmx:kPzoakc8_jk9jC4iv-WEqTZu5jnNeZJxZR4JSbSaITEBNtWbgxkbuQ>
    <xmx:kPzoau7BSrFGgoTyo_PA1CYGAey1sR943z5_XGLHZHfJ_ObFFdVmJ7Se>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7098678273B; Mon,  2 Nov 2026 16:11:44 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AFgPYeWZplpR
Date: Mon, 02 Nov 2026 16:11:23 -0500
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
Message-Id: <7ee779f9-db3d-4829-bdd8-1d09e3f74c43@app.fastmail.com>
In-Reply-To: <20261102-work-procfs-net-v1-6-982104a4f592@kernel.org>
References: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
 <20261102-work-procfs-net-v1-6-982104a4f592@kernel.org>
Subject: Re: [PATCH RFC 06/11] SUNRPC: let procfs own the seq_file of the cache content
 file
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A98E3140005
X-Stat-Signature: mxefzgseddwjyc1ytfs695ef799u8txz
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793653907-645090
X-HE-Meta: U2FsdGVkX181dqIoC3y7VOgxzDy7UOcpwFX9Wn3fTYb6kAvHNBiwWgpGn72BTcHj/VTiyDyjyS/Tuxzh4KBkt19r5b8VbcnvGJZTW3WYHZ39V1iNQRkqeRniaU6Ux0I3udZWnaoueqdEqkJdH8CVqXe1jtwi/XQSwA0P0YLrn4sEZMDRfS81Ey3UZBa16ZAcOkFjCo7nzlchOZXcv5dTiugKzi+WAP+PkeIEsK+WoZ0eLHexrdC3psownjCXFtF+qPxufhdxR+k2OM/MdQO5Oq9XJslGi7AnuzUWZAhnWFF//C+a6LqobgvaOGGG885qSzDubQiP45dVcEF0rPSPJ7oB7yRi9p18GO9BuhVFcIQqGM/vGt4IxSttspubXodbW+5EHtdv2YtOKEZLYqcOi/QrCNzcPA6osVNu7RvY6eeQmctqzkrn6uP2hG7Fi9BbEOHWY32II/oYAEF1XAup4eb6PkmWyqUkXr0g9Oxrp9aeZ2Tu7sFclU/e2GP8WgL+2gYZU6iCPGTHCHSTXOZgJp13r/rWMoFdU/n+snZxqwgm6l70JuxLvNpWJIgQD9FMXEiuQTYImUoJL8dbKWZtTR4F8wRkL5r3syIBC5DSjiDAhwXzvULrrROAC3rYP+dt8kyLslngmrSEaR/ugKdddzqnbgxszWt141nQXkCKl8zDPZ1H1Gz2SwWq773PQiQTUYG2ruHxvdtriJQVISe3hEMLJGP2Shwo93YBqw3gvDrvPLyxNrxtYZVANE8FbqfdlhjbySmOxO/K7ZeR6mG0aFQY84zM8wB5KeDZNCkPFe1iIYwNrc+gOp2KK4jRGuNrNV57TRNIT9TKV130qOoNn7qMJn5qkBgQUwwugY/LVanKHZfTY16N4QrOsUtZkEuugYxyrlJA4DBly5vO886mblrpLKS8fnanCa+p0RtjNvxcTdhjZfiX6UgeC/hJGL7gBQJRnIyjV3O2O1Eriad
 9C/uR8eV
 ANETUPnlNVbk1e3ujJC0Ql7jB8RU/dUvwg+bf5/ZyljVcSx3i/Q+uJOg5arWpJXRt7FG8v1mwdl7Ne1jTQI6jeW3Aj+G9j0qhbzdG7BHzcSOn62tisvvWRQjH9svjYLpii2w8hdbJOPUOzfp7fF7yVAbBqrsNRmaALviqspUWCXqRiJOOe/d+aef03ZWW6gD6cyxW/yiP1QwPJdo1YlCBTnXzB1hE6apjFFPkrU5ALzuS4m1Je5tnJsLX+TJB1f4SVYqO467RblXC0r5f9DCgfFvO4OcvuIRfoaYBf7N6U+uREv3ANU+iuTEgRP/E2n62kHZ0/FsKh2qbtweo8F95QWleb3kDAtoc3X1zKAwzW8F6lS5qInN64muwVvY10sp2EcLl98B4icKfFVoh3nwM3em7Jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Mon, Nov 2, 2026, at 10:07 AM, Christian Brauner wrote:
> Declare the seq_operations and let procfs open and free the seq_file of
> /proc/net/rpc/<cache>/content. ->proc_open() and ->proc_release() only
> take and drop the module reference and set up ->private now. The
> rpc_pipefs file is unchanged. Reading the procfs file then no longer
> holds up its removal when the network namespace goes away.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

