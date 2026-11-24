Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA7FB606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=Ns0ocBa9;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=VyCHGOD7
Received: by kanga.kvack.org (Postfix)
	id C96E56B083D; Tue, 24 Nov 2026 13:54:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C488D6B083F; Tue, 24 Nov 2026 13:54:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0EC06B0840; Tue, 24 Nov 2026 13:54:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6BE6B083D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:54:16 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 262D9140CB9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:54:15 +0000 (UTC)
X-FDA: 85470912870.05.67A69DB
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	by imf25.hostedemail.com (Postfix) with ESMTP id D773EA000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:54:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=Ns0ocBa9;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="V yCHGOD";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf25.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.139 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795546453;
	b=qhnqT/uPALAgrOr/hWXMlPStszlx+1/Pt75+bIniRwxfdEHbh9yIcWDlgMN/4EKSEy5FgU
	MPxlYYSP6NYGzbVlgixgNNLyNau8nnon8NWnd8ymx4BpOgK/1YsFhVSGX7G7xtRTr9Q9EG
	2ESmpbQCbAYCrCFRQ+yqSI654CaW0Z4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795546453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iJ0bZtF+M32WhmItWYj3FSa2ZiQSpvoOogcaFVHVH5I=;
	b=vlkFL2Ppy8AwAXUYcl/pUzQgZrKavep+30JXoV+mVf4QZmgEZ0ZUril3By+wLTVfehMekh
	IU1lrYq6qtLVHwMl87hHEAz8ZNnMueojPagj/mJdCqZoM+bGDJF1XBV+H7ZxvNlJeo0A1F
	yzIC5acfPNIMj+PguU3m5JuXFIsmyeo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=Ns0ocBa9;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="V yCHGOD";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf25.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.139 as permitted sender) smtp.mailfrom=arnd@arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id 0734A138029C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:54:11 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 13:54:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795546436;
	 x=1795553636; bh=iJ0bZtF+M32WhmItWYj3FSa2ZiQSpvoOogcaFVHVH5I=; b=
	Ns0ocBa9uuJQNTtG3QfiU8sUxKT2BVab79oK6XioPic07HNY7BbGUro4492vDSKa
	taWSB3j0rahIlRO5r8ZoxMAmIeofQrkEd2O7X1OMQEOOEmHkNvuaEYSDts/UAM8w
	fED4InNTr0trVvSv57ETj3yHni+DAOQy8IgrUckr5I1xjqbrfGUxOwoJi0smwrAp
	nxVmvZkiOxgeZLtuxZuUgSTF8HOJ38Mrh+Szpuf5yDk9lzFD74nKhq2IZnhfVZN/
	vyB/Gl1S/ltyMKRNSc+WiurJ6LH/MJ4UcyvYBvhtsIXVP/k06hqmaXkoDI11XeA7
	wlXBDaQ5dfB4kxGI+OVvoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795546436; x=
	1795553636; bh=iJ0bZtF+M32WhmItWYj3FSa2ZiQSpvoOogcaFVHVH5I=; b=V
	yCHGOD7HZXf+kTkcfTRyN6yTdKP309423KicUoIMqFh/OtFm+5uIv1vysvBFedjV
	XJFPWePPRM0CnxRFksiKelXDd4qxik7aQ3mMcyBCJjLxhyAF1/B4D21N2RNJubIz
	u5cBy+nZv7B/NkDxHFeW1hHCDPsd2Yncp7NFyXICp+R3pT0Y5ellhwQTcSjOD4Is
	qcejxkzW8ihZzqAnjwKGNkFDJQStwnjJ8vVNe8gpcx5sVF8NLwPxyCUUnJOe3iXr
	77Djsuz/1kfq3wwkXcMCZm5S41gIGVWAkWq3DEPG3YLiO4EDE4ry1FhRdzsZiw+Q
	+pL5WKOI4leoxTvwkIf/g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795546436; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:ex4GwVdrTw4qGTsP7NUGh5apjW2u6/iaoezL1BztTD1UWCa
	RgY++yyfFypOCAgXxAWEwQ29VWBG1Rtsf8DRCYkf6gtfReNRRJf5oTSonHd12MHB
	hxmscrQC4zFycHZDK9EQxz7LkGDUCLjm+GOxp20m8KPFX8hK/qTnd68hFtRRefVr
	K/USrmkBwnkTy2065h4cQUAYN1Td7XpEo5MnkTv2N2R109y4IpGab6WZm8JFxPiW
	veWvpMo0tKqpID6bCQICiZKEWwG6qAkCu2tTdABjMdFa3YdqniKnbX2BI3ngzY0E
	v2Z5IjkVSeDb/xz+zm2HYV0p1OGUsqedO0j5gzQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:JE9Pf+dIuvBMDyw467eQ/Tr4tyY4SBvJ9vbnWlDmBbU=:iJ0bZtF+M32WhmItWYj3FSa2ZiQSpvoOogcaFVHVH5I=;
X-ME-Sender: <xms:NN0Fa_Dh16pBjRQMtmAQtpYpz28UEZAAlNWef9QDlR230iNPWwpgaA>
    <xme:NN0FawWnt_cU2zPqxwlF3kn6lXR865LwUWDq-4TBjsqjqIqfahALCgQWW-0jyO7G3
    I2uTFidD6Jk0Jt_ZRZrrybQhsZmf0PkwLrG07cX5Ey9rp4FNHu-UqM>
X-ME-Proxy-Cause: dmFkZTFsQKpYLoHX3KE6zope7Xly27EYv6AQYyIF3Qau4aRC0vSHzWA0jMBeGZ/9+uCniy
    PTkF5Fmn4ClSCnUsMdxXtnQhtPNPNvOPsMvdctlUYyw6p+0jhYlfcnMwYC+ka8/fLSpuKw
    3YLhivPgri0MvBEeHeehNeV5wiFAsJv2bcNaHD7UboTSW+RjgcB42VuUlh1hahI0iQExPr
    +XuV8lAvetVw7YfrG+rkJKl9bl6k1+Pc6YG1mdIQsn8HBaASQD8dGrUNem4yjy4NNXFr2o
    l0vAJfxG5EW/9uTEMy9av1oYJYPAqHBvhuaThuRz9ZxrEhJBnZZaNefPyOfbd5a857jzji
    xS3AH0yNi27nlGbP2enOJqlf9wVeoOUs7OcWrHRUnaD4wGX3BucglKw1DWVVHUPxhfMt+c
    yYMsv9QYzlu0IncPWVnqsNMz+WiqY0HZprQifxi/zsPZ8ChkJiSCAB7jX698jdmSQw7t0Q
    wldIOTkPNxc4rzT0CMfulFrj4Rm5L/cie4t1IvZQrqsjE2CBRn8iUu7yiZ0dS2UrGJdlIv
    HMXP1d1uGpGRgLQ/rxCRTkol4EEsKGIX1Iz0tWkHIV/hA4OOaUelQC0/ml5S6Hx7O/VRRR
    HHsnZozZEW2a8iAqfQuYUL98uV7rqteWCN+bZ4WQQO+0dMzPuH8W8HlVGiTA
X-ME-Proxy: <xmx:PN0Fa_OfkSf0I2gz53d1q87MSYiyija7o2MtMOioAI-ZeTkir1jV5A>
    <xmx:PN0Fa6p4AcKgvKj7Nxl2i9GHjEd2VbenjcJEjgY_FbTxdjTIKHGJeg>
    <xmx:PN0Fa5WDuMRF3QKr7uInN4TtUt9GYOr8jpLSEeuwpRljz5xEyg6WqA>
    <xmx:PN0Fazu29G7Wm_IQCdCnlJY6WRkfF9-85rVjBcVYL-WZQOkOQNyjOA>
    <xmx:RN0Fa7HuB9LonHDmNq2kLPdcfAnhX1Syf3plWTxAvus5eCvT9QG1bsct>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 4968232A0099; Tue, 24 Nov 2026 13:53:40 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: Ai76fMdDSoMo
Date: Tue, 24 Nov 2026 19:53:19 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lorenzo Stoakes" <ljs@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Juergen Gross" <jgross@suse.com>,
 "Stefano Stabellini" <sstabellini@kernel.org>,
 "Oleksandr Tyshchenko" <oleksandr_tyshchenko@epam.com>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "Shrikanth Hegde" <sshegde@linux.ibm.com>,
 "Haiyang Zhang" <haiyangz@microsoft.com>, "Wei Liu" <wei.liu@kernel.org>,
 "Dexuan Cui" <decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 "Jason Wang" <jasowangio@gmail.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>,
 "Jarkko Sakkinen" <jarkko@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.com>,
 "Paul Moore" <paul@paul-moore.com>,
 "Stephen Smalley" <stephen.smalley.work@gmail.com>,
 =?UTF-8?Q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>,
 "Joel Stanley" <joel@jms.id.au>,
 "Andrew Jeffery" <andrew@codeconstruct.com.au>,
 "Ryan Chen" <ryan_chen@aspeedtech.com>,
 "'billy_tsai@aspeedtech.com'" <billy_tsai@aspeedtech.com>,
 "Bjorn Andersson" <andersson@kernel.org>,
 "Konrad Dybcio" <konradybcio@kernel.org>, "Abel Vesa" <abelvesa@kernel.org>,
 "Jens Wiklander" <jenswi@kernel.org>, "Sumit Garg" <sumit.garg@kernel.org>,
 "Scott Branden" <scott.branden@broadcom.com>,
 "Broadcom internal kernel review list" <bcm-kernel-feedback-list@broadcom.com>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Richard Cochran" <richardcochran@gmail.com>,
 "David Woodhouse" <dwmw2@infradead.org>,
 "Andrew Lunn" <andrew+netdev@lunn.ch>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-sgx@vger.kernel.org, selinux@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org,
 linux-arm-msm@vger.kernel.org, op-tee@lists.trustedfirmware.org,
 Netdev <netdev@vger.kernel.org>, linux-mm@kvack.org
Message-Id: <3208cde3-c5cf-4888-88f7-c77d7b0e5940@app.fastmail.com>
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-8-0b0d99d655f9@kernel.org>
References: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
 <20261124-late-2026-mmap_prepare-v2-8-0b0d99d655f9@kernel.org>
Subject: Re: [PATCH v2 08/13] soc: aspeed: convert LPC and P2A control mmap hooks to
 mmap_prepare
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: 75fgcfo8twjdjm36hb4shc8fiorp51ba
X-Rspamd-Queue-Id: D773EA000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795546452-868809
X-HE-Meta: U2FsdGVkX1+qKLoxf2U4r4LE/5KTwi6HIo1aLMHrCNhNilkXqcZc3JgSX2IgfPSGOV5x9gIZlFKJ6iq7/gziuMkDuJeKBpfO12X42V9ab00Tqc3x35FC0Lm8Q6gmA8LdMU/OuuHxI7FeTP4tJVBnpiztjOS+5jjQu1CV0nQeoVqCbdFXqD3smsQq8Innm/Z3/FbPOMhPZAMZMXYDIRpyg8AtpaOeXVbv9fc4DPI1pZp5p5jF6iK2FZ56UWec8tGOiclp/zRZsnJam5kMEIC5JJ3aTYtU2sDPfy/AyaIiu466A8uJaDIVIZWUPKM/QQ7sQJnvr9HkT6w1gjGXtbus2/HvFoD8rrmk2O1r5maGJDdtEGHg5Jr/dHahGzKfRaBTfdo38gCxOE6kjMgmrg+O9IqoDslKVSEE0eZVn4YQQ8u8JccqvaK1pUwnTYNgDrf8PDox0GQZuG1wOVe1YwAXfPoHo/g584i7hLvwTxavhN3awSYV2rVQrHOvPnOP76I1A8k65GLSx5LxJZtqcFPod7/SORDit8ztlwu/eGPq2MljMmZGMfcIb9P2AYS1dbpE4B9dz3DFZ1fSa6wiC2NM33DjwaNgQ2uF7hnyRiUCZCh01ifRO7L5QCeTfmpQiomwA+XOMqO6RRg7eMkrpXplaMAYIGpkICsmzFxsJArnKrX2e9pgt8XJ3RzM7f4HJBjbJB7/fFC/VllhIsWs665X7CavV2EOG4D4dISyMz1fQNtJTgkQyhKT4RZ1RKQSzFuoiVZlEhXGIbKUk05ysh4q+4KEfB2Yi7/9na6bx1mllWG0oOq1h+9EzLILyEhs87U0WIuI5doOdoGNpPjRonVIheLdyKmiO8yS+AgGs2wpRBm+Emmaj6CLjYa3cViwXgCEmbTNxxt9DQb963O6K4nmOM0RQFskYe5BCKmAy1qMTliA4PprRt3aQksFPB5aj3UadH056CSKE4kOj3qf4Yu
 dRcKgz04
 g1Vwt3GSG2cqacYJGOUgwW473Qnf0oDIWL4N0+d7/wrLBftpARRQoT3W9RBm52zK3SSRvL5+6xt21w1xkJOFIhwULQlB0S4kIMsS8TM7KOCAdL/G8cS5zOM39RRrTw43qmE6Az3yMbwOC7v0QixhZ8ATdk4jmr9YK6XbFTRlFaZiaD1WVo3x5ut3vXQ3tipy7kwYqO34LSv8thJw+w/EANhilTSGYbicZbvT8D6xzobSLJoVhaZNsBrKJLnsXcb+bANNEC2yM9ftRbuDocFXGXQWp/X/l3V1vyOvqOBzE7+nQT8u8KRZs6yjp+6WJ32ul83Pa/dA462tWxfAsYNuQDnSFUq3qhwp510whozSYlhcRa6t1SyMU0vxn7a9Kxx0XO3TmUq3Kj04E5nMyQ7ITjzZYZYYFxNQcNdWeudnogDlXKppUDS8HSML6TqyyiZNJyZd3F82nXAdo0VwgLCuBg72Q/1TkF7rl+VRZlxL7YIEb9KGaXFhb+3JvmH1ezpCY/m/N1qWj7cF6KYtWA7z4XbZpvpXQEX8ltk4/oVVVV/xwujqsAOYDvKTIGbkJXQPTf8At7vUlg++t6pO/jkYYEW7LQ8/BKjLVpRPNXnW9vZJBS3OmuV/niOv5vbtahCsXqPx247Bv9Suze7qZpvut4WvGJU9T9aVYD9LBygU9IFCzxmLLYAJlX/jeN7rj8E0FiFqojjTO8Q4rhX6UFUqPGO97j4OvVYLzBK+K1GR8DGZvwIpAizz3LPkGZqWHulYrSp+C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026, at 15:02, Lorenzo Stoakes (ARM) wrote:
> Move from the deprecated mmap hook to the new mmap_prepare hook for both
> the LPC control and P2A control drivers.
>
> Both remap a range of their reserved memory region, so use the PFN remap
> mmap action to do so, retaining the -EAGAIN error on failure via the action
> error override.
>
> Acked-by: Andrew Jeffery <andrew@codeconstruct.com.au>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

