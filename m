Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 808CE606A911
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I6l4/tba
Received: by kanga.kvack.org (Postfix)
	id 8E6886B05E8; Mon,  2 Nov 2026 10:24:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD646B061C; Mon,  2 Nov 2026 10:24:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ACCE6B061D; Mon,  2 Nov 2026 10:24:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52AC36B05E8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:24:00 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D92BC80165
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:23:59 +0000 (UTC)
X-FDA: 85390549398.16.DB44407
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id E6DBD2000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:23:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I6l4/tba";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uEqaClazRJnTsShq1vBrZThkV8Ug5LupXRrZvH3pubU=;
	b=fjy3hc356CuFYlWAsooUjdoOwn18kzsRLxxaqXUIet5qz58Nnr08raVHBKiiOvo28EX9eT
	/GBNSDKf7nqd1O+dLk5/GaW3hNlL6Xa7TTopRrO29k3O0L80n58LJB0qvbnVusEaTLPQSK
	xhxYq7xv8CcpxK0yLsgRbNd6hc7TLKo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I6l4/tba";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633037;
	b=HC4mgIQvWq7tJE5KVrPUXgqRU5k+vOaWZGYajEeNpcPK0bwj0gdfsCKtSvKNUi2jJqYIdc
	YQLojkYnMU8TXaCzwxvAKbdBZkI57f+UVB7cyclma8GkD35+zlkOWyja5GKGLwhJBFWNzo
	5kOtR36OnhYqxmBU2AoTvMVn7buXW2E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3208443C38;
	Mon,  2 Nov 2026 15:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A1A1F00A1D;
	Mon,  2 Nov 2026 15:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633037;
	bh=uEqaClazRJnTsShq1vBrZThkV8Ug5LupXRrZvH3pubU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=I6l4/tbaekcm4F5Uy2sM5lYNZJehob3zbilnEvdVd5Be7BHLSA58cOrhPrILPdFvq
	 VYhCXzN+7v7yzkwvPgGyx14entsyEm+617RN6ONGE//eK8k+1BetRrKVHulJ5QbSin
	 PhS8HfUZqzzeMZUZO/v6APmD3sn4yaMgG66Qsqn8sOS9bND8zFW5xc3DAvH+pJN+zW
	 2O5TNMh5qcv6DV4Yetx+J9g4v/mnh/idqce0ZMwvwkWvvLBPw7dNas6Ir9cn/TKgi3
	 cPIc+u7eIO45sBIcX4Oa8V6/wXDS2qubRfgYQs1GfGIeyTgMlWMeauo9Hh77UxYwL6
	 FfVTg57cgsBVg==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4DA53F4006D;
	Mon,  2 Nov 2026 10:23:55 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 02 Nov 2026 10:23:55 -0500
X-ME-Sender: <xms:C6voavPgQSRhi6XwAzM8RnPtl2Qk0fRj95s09_7pjCvBkgc9wCgEZQ>
    <xme:C6voakztuZUoJrF-uTAxl2B72x3pmfwEKg-LcE13JEST5qccjmIjzKvqrpEWmzfMg
    -nHWFjmTR6858SSLl1zCNNaUAFoAnJNEx_iFa19V0Qt32rVtZen6CU>
X-ME-Proxy-Cause: dmFkZTF+ugG07b1xzJ9p0xcEFxqeAUuLkm+cBz6ii1+M2o4G6r8HqTUbbTFu18jUFSJc51
    Uj/WAYx1vLl1HSE3ylvEypL7jKJPv1KgZWPB2jf1fZVCtbPTSv1quZFsQjIyJhe9070QIh
    uQLf2wtG4yD+ojXnVZ3slOSBiSDghElaqTK7IeYJyToLF92DkQAYc/RGRRPOyD8hBeRAvE
    Nch4lTm0R3j1fupNVliv+Zb3ueLjvcNJfLsUEyktNZuL98xLp9t29seWsvXUNWHVoJ4uvh
    slBVaqCA11v/MsN/MRHGG05E/DWbmBLvDFJPHdsId2elsukPHwuZGosb7WcPszwpbfZZgV
    bm2FrNuJvmDOIFxayRrMo3/bGXJGRqqKBPvBIaAv1rXkENYn4zSvEA5QOidA5pB3XUhmos
    x08vQ9jzlrTeM9JnMvw3se+lrV299CFmE+fTg+hlbCRXvAl6sZE79B8vu6VSR9XtNh0jVy
    C4+hYe89om3miNRS4TpzQvyb77peufEKiolSIU0wmyCGRwtb2Us1G/qCaXB0fxyzIy79cY
    1kg6qGRDh7uw8Gww/mv7TrEgW8mpkzBuVLXohTCxaKYorV+OhEcRntGnKGm/9Exa96NKy3
    AMQrlyXBmDZmT3LrcryBxr6Vx6LQ+RBaOIY9+Czn08jGf4XpaPjwaHDoTtxw
X-ME-Proxy: <xmx:C6voanx9pQkwlSkK78xJaos_d5jwrX3PPHLb_TLVG8fs-X1Spep8qA>
    <xmx:C6voalKVyQAGVPcO-wGv3krzxEi_6FtQAeAVqBnSiS8ylmXpqCdlxQ>
    <xmx:C6voajxgXNF0PnlEcauvcL5M9jsWsivItl9e9M8ymKswT8wDOTEnxg>
    <xmx:C6voaiqnbxtboTm78N0amXUEhxn5ytMWswtAcUdzERqqQMeM4JMAbw>
    <xmx:C6voapU24fdZKXD-sUGTpbuIUcSP2EFmKemoyPTf_TL11WFoX74F0nG2>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 15863782738; Mon,  2 Nov 2026 10:23:55 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: ArOOpyqnvtx-
Date: Mon, 02 Nov 2026 10:23:34 -0500
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
Message-Id: <58f6bc57-d6e2-446f-932a-8104b73cb654@app.fastmail.com>
In-Reply-To: <20261102-work-procfs-fs-v1-3-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
 <20261102-work-procfs-fs-v1-3-d09a996317b3@kernel.org>
Subject: Re: [PATCH RFC 03/27] lockd: let procfs copy in writes to nlm_end_grace
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E6DBD2000C
X-Rspam-User: 
X-Stat-Signature: 9ngnc7iis3fzr9dex8zbbneui1uu6fyh
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793633038-624316
X-HE-Meta: U2FsdGVkX18JWPmeQHpV2EnsGpcR8IPlaE2MNLG9C0i3QhXTMXBPox0tGoP4xlTPyHIBKwYKrb2Bo56VfPltbjROp5l3eJcfW92IEeLr9rmxG0RHjwNcnCD5bUTR+lrUAq6Mrp6C05W0M4RfIpQKn7+VZoRjtCU4jgJekY22U67Wbi8PcJ36bZAg5KDbaRPtocsUcjH2fewS34qlQAAF1aTGqia4hHvktkmGI+2W6lE+O0O/ArhY03GP/EVRuRJfG0T18fAhbK4U7fCS5pFWNbwbYu+rD3aiZkC9PuXAfINWdgb3Ui6IPUbT/Rl4/w3ujb+PW0O4HP31uY5nnPSNsJzbCd+GBu+FvAe/sB8PI5paFnFd6Ye1MCV+OOcIhXZ7X3siJceA/MzNqzgacj3bS35GAGB2EO2L0ZBkA08+BHLiBhCevlrof2mhA1nUlZl4uJLwlAmRz6TREtRRybTaRApStlhbjUyTnWR0moMOB4nkIlMkrM/G6vZklf93pDoH/r59vGZXaSqY1BjniHwfPgf3HlGwzD3WFr57whhpWsWQv19yKTgUMbspZ2cNjhckI6tmgB9TsouJVLaQTtMuwWrejH7KcIRx+IMzeXYsB/aMSuwwfHF2aXhqQ4AbTvujQ/67cN2ZRYiyM2teGByqM2ijiiPrPwKT1kDV07J4usVcke7HB2TExUpGxJCyzBz4sPq6SgF4jsmfl1J/2Y48mHdX/VmenupQL48YdH0xUgrYTdumZdbnIJJfdMMA88lJXqXYcg4O9diyBbxKLZDAI0s9mdRwUaMkz1I8A/zrE+aYAt92cPNmGXuAJPj+1YfVPvc3UbEjPdLQvVNyA/PdzWjSY4tJsRMPaDV3yTQo8Loyns8geS9Rcevn05PBkSD3K09pxDi49elJMIACII9mK8msaoiWy4nfkRot8WZGSV+k9Ie74gFLtqrqqBAcW6va0WVSQQT4eZSfIWSMeXh
 ppM+PBY3
 BS3qQjokofoHDg9mhiYgqffJnZuX9E98N9WkrcdDTpdNEUMNTbPIPZPJomXln4xLlPxyLHLcaBGW0RFrtdkL7vjATrkP14BGTbGGuIwCtx18BQP1MuS9xuCswTMiITMIaFfhM1zHF9wrJin3G7t3YSEq3x29syEy5yjFLFrKaIj1QkKNDURnMKpC5/uhjgMqIZa4bghslzQCwJMeCOMRds0FQykzG3sDvo9boDD7cafhKuYTPl2Lv16gLkADnrtYILerdXkkzC4k9IhLN2PSukgY+V8uidkW3niQTcjl0Cg2xfnWtmV3SRwMYQU6hAHANF0OTrIMbL/aLlzxZCBys1g1B1IEJyflakmbOOSjPxSxmHhAICDPBhyJQ1/erJXrV3nVXKRMKahDXslDt/P1Vit0WOXlyzD+zAzeUB2f42WqdZbWDhSwETijZ0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Mon, Nov 2, 2026, at 10:07 AM, Christian Brauner wrote:
> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry. simple_transaction_get() was only used to get a copy
> of what was written, so look at procfs' copy instead and drop the
> transaction. A second write to the same file doesn't fail with -EBUSY
> anymore. Writes larger than PAGE_SIZE - 1 bytes fail with -EINVAL from
> procfs instead of -EFBIG from simple_transaction_get(), which refused a
> few bytes less.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

