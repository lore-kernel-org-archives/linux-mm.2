Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 553BBD2FEF4
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 23:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B508F6B0005; Tue, 27 Jan 2026 18:32:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE1F6B0089; Tue, 27 Jan 2026 18:32:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DF1B6B008A; Tue, 27 Jan 2026 18:32:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1FC6B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:32:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D42B160381
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:32:04 +0000 (UTC)
X-FDA: 84379344168.25.14DF24F
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4C2B9120007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:32:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TN7wnWMz;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769556722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8ffCxgqfPNNOI1L/bqqAX6TLyKV0Tim54t2cjmn71o=;
	b=JMV1pKAxjpHIba9s/GH+BBSP3dFJYsebUouixx1gNvmxmvzp+gOe4T7/RVm8T0XlC+MWUO
	Y0l+XznyAIoXDwXFxkmgrV//ffHSvtcYNkJ4pNqXD6anRlUD/Jniy53Pdo8y7Az2/wz8uP
	S7l50as68rc1Lfc2Yo1gFmxORyvhdjg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TN7wnWMz;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769556722; a=rsa-sha256;
	cv=none;
	b=g8Ghz6h9OgzF9M7cWfRUxfJ7hd8eYnDk1BJ1pCOhwE+nE2o0BLuUdszB+b/wvopFWUO8ct
	SfUlrMgdmDqqBmlAS6dKDw0HUKjaWQq6RMf8oPDaeTNqXREhnEr8Zd4b7/6u6j50Q+NO5V
	xjnyU3ZQt5DX2ywYV8jwy+0dhQuwcso=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8c70c6b2bcaso106991385a.3
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769556721; x=1770161521; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y8ffCxgqfPNNOI1L/bqqAX6TLyKV0Tim54t2cjmn71o=;
        b=TN7wnWMz8WheTMWqWKmSb/Dk/SZrAOP8WbRDkftKLP/FjtVl0kQUSk8WdtBqgUXSbE
         NLtGQMKKYK3RMWG2TzW8rKSaPxSJP4viJl7xOVPfXFe5Rdm1hUtc0oTO6qgiceUEpwFa
         j9LKQ2CPIpO41TpXkfMYQI1AbAQAa5ojUgW0zpyGfjEx7dUMWPSWBeHJtKYuZWOTGlW7
         Y3CoLlsP82j5PrGFdSDiMUU2DgC9xSrhu2xxIvzL5ZOzEPuyGMvmtjHHrWafNhCcH7j2
         1yFD3tcd6KMDD7Lt4kryOOJOvcl0JN4+YawZ/4o26OtUUG0w87PkOKE29JsaO/IcJrbn
         aPFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769556721; x=1770161521;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y8ffCxgqfPNNOI1L/bqqAX6TLyKV0Tim54t2cjmn71o=;
        b=nd6APoWYkURbcLfq/hZ7kzZ75DLyGflmz+yhwSvLhiKrfL3KOc7qKnszTR2Fz6bnDK
         /HhzJufJ7WJwNK+aF9kPgfigEE2dmCC83Otvj4TXQRnDZyqLwUkUlYS/1B4RJhiq2OJn
         pwOZkm9Fyzc75Tffg+hnXPCbQpb67Lxc6Sy2Aa8v1o1cTeS6yNYwKOEgxaLJtpcE2LO2
         AxPLjMwqCNUXk7jWJrn08pQGPSlvmFmksYykr7u4HX8AYkTcVjOjENZb89UEcLLmNCNz
         UR5lvfnTU/WAmqQWu3vBqS3StFHUVMjMii+DDpwFdaCEaw9oQ59N2cjl9+jBU4Wx3JXH
         idAA==
X-Forwarded-Encrypted: i=1; AJvYcCWe2xSfiIVnZeLkRl3B6QDviBzxg38PUt9Tb/RNb19P3MW15P4HWG59vQyA5VBiEZXrsFYBzncjVg==@kvack.org
X-Gm-Message-State: AOJu0YweSKcVa/GO1L5KA7OmNkSN8c2OFbb2Gi069hqMYPsHUbGBaiQi
	WdG506/IeOc0sQ1if1eoaKmaN+G4fQHFEL7yGBTGFvAJDU9NYBeKpc1Aa7EE2tcSHAo=
X-Gm-Gg: AZuq6aJudbHQmfSaV3HxjNRE1HlJvzo8VEy6+oAkhmBl7WjjAhsS2GOdCgxni/4pAUy
	pTnxGonHvBHXVLKMlKjh3UnAVrZjJbtgkTB9rQ4bik/AH6HKF3d1T8uupK5JAXa1NZiW4p0dodd
	AJWhMIAFhR030mo8MxvB+oT0/83x0CotxBANGQmOloWjpii/RxTOiDJtKuYZf021XLmUHgYYMAB
	BXpSHBtarUMJd6CWB7y9IqGiOAQpceFuj2Ilf4sD2to5kCpnVHl39CKWsfaQlKl1NOo2AUFff1B
	srETpdfku65Vz0VOmP+P4mtk2BFwi5a94SFwLHfzDt+X3D7Fi6lgtz9RFJ2L/WrT6OnwNgqYMEt
	9OBmFwTaWY1YDC5JuwuUOqAhNvwGZMUwUo6EBeM7fB+etvcUsngnbHksj/baTu5rYE2iUOip2Vd
	XX7godH8glsM5Vddubh7NrNvcpwk4IpG8YAVM21chvY/V+8pIb2A8WXaZ9M3gW3UGTxkkiWQ==
X-Received: by 2002:a05:620a:1908:b0:8c5:2f70:c62b with SMTP id af79cd13be357-8c70b92d7cdmr423216285a.85.1769556721349;
        Tue, 27 Jan 2026 15:32:01 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711b98539sm71997685a.20.2026.01.27.15.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 15:32:00 -0800 (PST)
Date: Tue, 27 Jan 2026 18:31:59 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 3/8] mm/memory_hotplug: add APIs for explicit online type
 control
Message-ID: <aXlK74ZlUf76nBE_@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-4-gourry@gourry.net>
 <b3d435d2-643f-4dad-9928-bc7fb5080181@kernel.org>
 <aWfR86RIKEvyZsh6@gourry-fedora-PF4VCD3F>
 <4520e7b0-8218-404d-8ede-e62d95c50825@kernel.org>
 <aXLCAtwMkSMH3DNj@gourry-fedora-PF4VCD3F>
 <20260123182526.00005ee8@huawei.com>
 <aXPIGMVAvVEBgFhJ@gourry-fedora-PF4VCD3F>
 <793fb531-1fda-4de4-b73f-fb46444ca613@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <793fb531-1fda-4de4-b73f-fb46444ca613@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4C2B9120007
X-Stat-Signature: 67zwk5dssfix76mn5arb7zut4ux7ukgw
X-Rspam-User: 
X-HE-Tag: 1769556722-736154
X-HE-Meta: U2FsdGVkX18FBtFqsRfPAEjs+1DtJnweyd0aLIL6SdGOpMOWR58fYRICZyVXV7skeoo5467hv3zDHHl6Bc1LbziFtZfEqMwkNk+sNcsuFxRe72JpIm/KGdmtfRPMf5Rp5yTB0UolriTo2KqvkwLjc1IwmjruRG0phuorKEsrC19iQlpKHhWt4cELWo3xzDEPfutdkzs/B3yGmt6taNJ30fzldfBWi9Z6nV6L5dR2YPN01bIeWFvc6G7El5Btlw9T7VLYZL2lC/nfID/m5d9mSPAjsWbkz0sq8sTseJyHh61cnsSFYh9da++f6+QxHPiMz3avB8/i3anf2i3AGYYjK4A66aiqHGzjFpyDTQGLcGqBdSGpz2pzKcrg2WRM7LG7P/E9uiJeCVjtkAWHeGGvbT31Xx7r1NLuTUUEvQ1B1VtR/J4hXyq4dx6NNGD0Syi4l5e2VuzSSmkwm3pJra4Yp7bBY/9Xc0Q3whQvtiJBFBKNbGCDl1blQwGuU+6DozP+jOdYP8Jf775Ra8N19irdVMF4wSP1fxfvaHvgpGbyqmkvaBmBXUKzVQbNd2WFhzBIqu9UNb1X5vO9AJoLhIAJuVtmpN2EOkgbqjSYQuhufMjLEeVXgI1T22SbAUeHDiKcV1up9HUnI68AKRmHkQEIcpTwB1eX01k2aaUz2qlXnkOIT84d8FxDFiSsz1yDpOBTvAJfCqbCMaoiGndcynGkc0fx45dF5m9wHPTUvrN8f1Zh9XY9v0gL5316tIuo9rURwoO6IH7harYMhSSQTuHcrsiZIe+6+7YM/RntEYsFmo3771RVIdCMTd+pgbCHbAWyc8oa/MB2r3qc1YDZbwVjt1OQaZgrKObnNEL5lSK/rGDmD2YxNt3nJmooNXz2YNZ+RhJn2ue3Z6gaNfUEtoslbta+iZ5Wq5OExJ0+vg8IdQkQOryNbOb86IrAQ9s9QJ+Lg5Ulzmdppjgd4YzHsJm
 fwBKIFXU
 llHSlxr9L/03UuaEdIGlqs1yKdI9Oto1B85S2XpIzDDrjF/+z1NBotBgKVZbjOAEHu5hP0P3qsbXAqinKEMOdwrnuLl6Jvnl4nPtXVQYNChVjije3uF0sYNwtmq3doOFqRk7pf/ft2cVAMdJCGA3p0TRhv+E1dKFCnWVDPkmVbqKMOCVwON0UiGTbHny+EbZLQfqb6eibqOWpXav60Rv17LeCFHNjreBM2NdaqPfUp9jZ2c48pF/36kjlvxP23SlAuHqgHeFRvhN5o08kB9LJ09bL4GOO+Ly5dnxJFrx6uJnHHKbC++/rmj2/hv2rdtJbKRvdP+FKwM2aGUNEAZT1NkzusdqRdfkoty5fUUIi6osYJoGbnGS+JoIh1yVM6t5lkBQXn5HcsDa813cwooyrBvzPDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 12:06:01AM +0100, David Hildenbrand (Red Hat) wrote:
> I'd go for
> 
> 	EXPORT_SYMBOL_FOR_MODULES(__add_memory_driver_managed, "dax")
> 
> (or would it be the kmem module?)
> 

it would be kmem.

I'll let the accelerator folks argue for loosening the restriction for
OOT modules, for me I think this is sufficient.

In the long term, for the private-node set, i think this might also be
ok, as the intent is to only allow "enlightened users" access to private
nodes anyway - zones are less important since the driver still has
a say in how memory gets moved there.

(e.g. compressed-memory is a demotion-only target, which implies only
 only movable allocations can occur there... so zones are mostly
 pointless and the whole policy setup can be ignored and the original
 interface can just be used)

~Gregory

