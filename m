Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5028C982D1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A6C6B008A; Thu, 17 Sep 2026 09:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA7A6B008C; Thu, 17 Sep 2026 09:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9306B0093; Thu, 17 Sep 2026 09:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 712376B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:44:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3B58C0345
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:44:38 +0000 (UTC)
X-FDA: 85223374236.08.AFAC1EC
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9CB9880004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:44:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=HctIIHov;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="S StFEGz";
	spf=pass (imf02.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.157 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789652676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tv6AvKyUBKOBYVm3p89JvK4vd3gPLoZ8aFTemFA9YCI=;
	b=sWS4WREDrt6ZLzDd840GSf1q62KjnUeek6llddRHX7fwcpoh6pA+vJP1NTzSTcoaMmEpfH
	Gv+8m4vc00yE1LvQDb0IEjMBlq/0S1JFzW6IkBNgvkY05BDBRYowRyAn0eGnMCk7ARTJNo
	kk9uDRibYV+cbcqg5nIAnBVp2O5rFfU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=HctIIHov;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="S StFEGz";
	spf=pass (imf02.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.157 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789652676;
	b=DxFUaPXguAKR01URhQfxxqnGfa4fPUbpQT/K4eJz+GjN0jiy2fczsZXcPnsCEdGY6H/ppc
	Oz0ZQUJ9QP7ci04leGw+C6CQU8HfE9HD+ezva1RdX+oAxU+SeyXN7ooiImNyIjcN7rAFnS
	oX7T2WryS9OKV3aDjaPwbCxgXMw1+aI=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.stl.internal (Postfix) with ESMTP id F249C7A00C5;
	Thu, 17 Sep 2026 09:44:33 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Thu, 17 Sep 2026 09:44:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789652673;
	 x=1789739073; bh=tv6AvKyUBKOBYVm3p89JvK4vd3gPLoZ8aFTemFA9YCI=; b=
	HctIIHovHKiSYvDiERhQbil2j0rxOiLLU1DR3yhzfDgVf8OBAturF4DW+rjA/pvm
	2TzLUXFsqesfBe/VzUjY5Ju64T2L/iMnYi4Iad2YoqCjrFCCtJcrFNty7KYaAkMX
	Ee/ThGhSNY9K8EqUjlX3DBBbEx/iD4zw0n9T1lAR0UcjIAiS2QIu/DGeFtM2gKsx
	vC1618xkmUgbuhahywNtoXIoFCQd2T41JK7SONpIEAZmn+k+g8Jw5bH1gN58C5uA
	t8Lr/iqGzj6AwyMMsO2Hr/46k0jobJDn5xUdIBJtFKTOKQynTNruPylRBw3+OFm5
	rALKY7nbPduQzYQgGCpRlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789652673; x=
	1789739073; bh=tv6AvKyUBKOBYVm3p89JvK4vd3gPLoZ8aFTemFA9YCI=; b=S
	StFEGzxtmEHfc/qCz0zCotM/62OuKzHd85UKp5on/sqrapd1073iSGEnIW7cbSU7
	x2iYOlCqOJmN9CH8dnJujRjyRNx+0Rb73k/x41hsFYPrlYd2ic888Qg4bHieUev0
	3FFiY6py7o5tIBq3fNUbqObBJ50xldle8fiPYdOH+CviFb/BaFBlsuOtg6vFTK5D
	5Qr8IGCFMBL7Va8qzEd++eIm+bgE3qiIFyV3deBWLoZagMOgLU+IqfH2zXVZK0sD
	MxphVkaC4athozVsO406Gkt4RMZ6mI3CfIbWSGKuKSb2IR1EmHhKSgL2cJ3oo/Cw
	LNnPjasrPOmybL2sjzNEg==
X-ME-Sender: <xms:ue6raubhOIm_07ibcU_1fa-IfTv8byRULWi1LALnQy-fA0E2tY0Srw>
    <xme:ue6rasOmwxcXa8Wfg2C-_h7nr62L9J8dQar2w6fePo7tE4wXV0xe8LEFTYt2la4PA
    KUxM64DVB6RS4XXJQMinIIyzgI_tpBcQtlz_SbRXvdozZS20hX3LyNt>
X-ME-Proxy-Cause: dmFkZTExMucRjVTWbs21V42SBnhmaV4MID8KsqHtSlc5cs4YSlrkOBHN5kHw1e+1PjA916
    9qrZOYYnJrxL7qGwwWQpGSNzj3uskNb1QR5XO03BL513/hPDNlb+fwDHlSeoO/Pnk6whk/
    LKQVd28yHC8/KBccPHePZI6mTeqh7yKWU7/09ViA1FxBpR+uoLt/wrYJds6oeJvJ4T29MG
    ali7NZeCPIsmZJ6nf39KUC39gTsQlaZhWsinf8igZnwI0CQL9I7h460JI5zfd282v19One
    8AMUBGUCj/m/2aPL9jLGr34OcqninFy5SCx6sSEPZxU8KripIQ9SH8D3iL5s5EvCzYv8sI
    wZjcD2Bn7eiQwRwVXeqeR/9N2Y3tP6i9ckJC3pgPUvWLAjUcibwBKHIY8jh4h+xPZzq1nd
    TPrj0XpO6qnyktQZQKsYUSyo95ZxXoWVkoA7ifbMitPAufHtbx1Z3XLM/j8Q8PglVwx6HD
    6GYlJIWjRNmErVFsasLUHAKF94+gS4YDbgUP5MUSiiG2DK2pcD8Zr32GAbYbZMY6aIqxvj
    DGuJJ9M61UrNiu4+tC5HCX02FO52ZhZpCswYDg3LN86DXC44SZDHIDoIqtdOb2HgBaioMs
    Mc9xIQ5KTHz6ivWOO1NuhCfGmll1SfbHC98gRcXftXYmOy06u0bj6SjFbNEg
X-ME-Proxy: <xmx:vO6rauwaldgalYcXLr1iUTZ-Yqqll9kaYJgXcGfgFOiCmdk0O1-4vg>
    <xmx:vO6rak9X4skk0eo5ap8breFmETkR6IBJzZCF4GfrEu2e7le3oOg3IQ>
    <xmx:vO6ram_ZY1uk8OnoV0dvj0u_2vAdP1GWb5CobItxUECZc3B_2rG8tg>
    <xmx:vO6ravfpWfBhtWEhSXDKDQePAwXV4Ir0NIoNrn2v1YqONWlZnIVUAw>
    <xmx:we6rarCG3xGFO3pdABduVOIx9yvQlZsGjax8CXya8lN4zOy4cyqZ6KEq>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 7306C32A0084; Thu, 17 Sep 2026 09:44:25 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: ACGBcqtoOIMw
Date: Thu, 17 Sep 2026 15:44:05 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Arnd Bergmann" <arnd@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "Kairui Song" <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>,
 "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 "Baoquan He" <baoquan.he@linux.dev>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Ridong Chen" <chenridong@xiaomi.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-Id: <be7213e7-db2a-44e2-ae36-7735b17c20d5@app.fastmail.com>
In-Reply-To: <d832c2d1-d691-4583-852a-f05d4335e9ce@app.fastmail.com>
References: <20260916083456.4136132-1-arnd@kernel.org>
 <20260916162816.39f0f33f6a48d30a71be3575@linux-foundation.org>
 <20260916163044.3daa3811d9b2bf7d958f1f27@linux-foundation.org>
 <75939625-482c-464f-83fb-fa12d3e1d79c@app.fastmail.com>
 <20260916230330.f0923cdb679de0b39d1c5d3a@linux-foundation.org>
 <d832c2d1-d691-4583-852a-f05d4335e9ce@app.fastmail.com>
Subject: Re: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized warning, again
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9CB9880004
X-Stat-Signature: jecexee81idg5qdh6txfrdsixrpoaqmc
X-Rspam-User: 
X-HE-Tag: 1789652676-210293
X-HE-Meta: U2FsdGVkX1/31vsnCrpIHcz73KcoGhyE/sjN/9UMr+0zVvU5bJV4RNouwEF1cZmAsWxZpaCp+BDczqKQuf4qejtD3E0xy+T8ZuaKU+LwBMHx/hcCTLREAkpuTBBeGKIxBMW952mKvPk6TMzL8m9kxG/w+wEhpv1gt213DwqQf06PVBKxN2D+Xs3k8t+wahNCf5UiVAVILDQF0xqe3xDnM+ODViA+0vBof7UD+R7uMCN3OcZpo6uNNg3V+qXQgkIbsAJZxSpaxhdyF3+vtoPueQzdeMlsIqeTj/OXKvDzDCHWPcPGDbt8eroSUVcZWR0smEUsmFuT4EsFexCbqwuU1GwVvNLprFgxLc5MqAo9VqfVEvHjTLMBEvq+j0X7rZ2japHCu3KjxKKQ1swCfQBvewkNKxdxv33cx9gXOf0bhhu9/wPA0C1YhnuGGcqIgk5SYrb2RycTb8fXeWMKFa2fny+XNj9jwKVcin+6yuqM6pVEWVROpdO0xX4DNOFrkhooVDmAAQcxIthHOt5yD0zuW9134ewwLrCXz/xIn0V3na8+1uym/2bIXFClMFYwCPZ2CLp6tD4/XI0MG5qpUeNEw2e/Vb4id7k1iqjB8BxTKO9tIhkLC+EpxU/97UXBrngns80m2TUQlD8hWTgxTb3y257Td8WFvc85nrv/q00G7KNZymejwImD/sYgQFDCGEzPv9BANrwHEEMFZ5c7A0/VKCEL2BNvnVaq/K4UWnHqQCcytHa4cQjwEjvu+2lM1k6CGWmoeZ+b13cm51hdcFGd71XI9v3XSATBbMbBtRdZJoLk+n6pRkbNSzUz62lN/d7rABNghS/DNA3e2ev1QjQB3yIBRs5asG9i/vUHrfZjXyRMBun4q/j1TPNtQr4+SGUL7EamfcwV7ZTiHD8yItDRNohOmbBEaax6iU8YnqjW5eaiff7NLufdNZe2qOUyNsQJF3cDMNsUNMABv0vS3QU
 AmVrdfi2
 OSeYGRTtZqNUMHJk3rn5te8pjWBJSGQJdGZGXFA4qG/yArrIxfKoDLLSvTJccOAJw6wmQQ8fU7GhQItTGRuQRPqABdLeu6C8MspPuHAzeLG7RD5yX1Oc1E3ZsmQuDuf1rBUqmg+wcNqDBqCx3iwQ14PxnpWgiga9+Xwri1CSDCNgiNoQYPG3DqhyEZow2JSVPaSQkuvPyMwt754hTvREzIkcqLUnJqqGwSpr4hDQX+88tRpJdcac2hvpHSMwQbf+5Mo35JPLDJinqOv/oswgpJIWX2K5vy7LZ3d/mR1W+dYJGJ0CeFdvGMP81Ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026, at 12:15, Arnd Bergmann wrote:
> On Thu, Sep 17, 2026, at 08:03, Andrew Morton wrote:

> I also managed to create a reduced test case, see
> https://godbolt.org/z/xofecssz4 but this still doesn't make sense
> to me. I do see that gcc creates a both an out-of-line version
> of read_ctrl_pos() and also inlines it. Marking it either
> __always_inline or noinline avoids the warning.

I now reported this as a gcc bug at

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=127454

Let's see what they think.

    Arnd

