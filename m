Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 953A8CCF2D5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 11:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8439B6B019D; Mon, 19 Oct 2026 07:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C3C6B019F; Mon, 19 Oct 2026 07:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7595D6B01A1; Mon, 19 Oct 2026 07:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51DB36B019D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:00:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDF621C3F73
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:00:21 +0000 (UTC)
X-FDA: 85339081842.20.30A2642
Received: from prod-mta-13-02.swg-srv.net (prod-mta-13-02.swg-srv.net [185.255.28.35])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7059FC0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:00:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=vates.tech header.s=selector1 header.b=EY5uvsdR;
	spf=pass (imf28.hostedemail.com: domain of prod-mta-13.8631fc262581453bbf619ec5b2062170.1a153d1b4d20008425@swg.vates.tech designates 185.255.28.35 as permitted sender) smtp.mailfrom=prod-mta-13.8631fc262581453bbf619ec5b2062170.1a153d1b4d20008425@swg.vates.tech;
	dmarc=pass (policy=none) header.from=vates.tech
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792407619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=H9KnLklLsoWFmsKsLymSdlFW5O3LN78kFpOTGXUDWX8=;
	b=E68RDZjMrKECZFdVUuxAagiha/ZdazXucMGiiKH3I5KRB2Qi6qBGNeb3vpJrZg8MX5OOXU
	uujjfgl3nenq/PMVSL0sd8hbt7E6NOX9Nn+K1y0II3NanAc+DZQlwg0m9kXNlE77CkxjNj
	J21mSLcxzZP3qAVoCVgP5PMC1Ru2fII=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=vates.tech header.s=selector1 header.b=EY5uvsdR;
	spf=pass (imf28.hostedemail.com: domain of prod-mta-13.8631fc262581453bbf619ec5b2062170.1a153d1b4d20008425@swg.vates.tech designates 185.255.28.35 as permitted sender) smtp.mailfrom=prod-mta-13.8631fc262581453bbf619ec5b2062170.1a153d1b4d20008425@swg.vates.tech;
	dmarc=pass (policy=none) header.from=vates.tech
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792407619;
	b=t0WkGZmUUqMKFaQ/m3H41eVDTUNVuFS56tIJxxRJ7ssBnbBIglweWfrbpf/E4lFoh0KMtd
	PCNQ8tgHKR5w+gSQhDPc+CAlqHTOPA5nOIDjUrZPA8NSY+xBmgCZBihzHfDbPoiPJZidmV
	WcpRwn2yIDcZ7RokILQ2tFgmCSrZ5uk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech;
 q=dns/txt; s=selector1; bh=H9KnLklLsoWFmsKsLymSdlFW5O3LN78kFpOTGXUDWX8=;
 h=from:subject:date:message-id:to:cc:mime-version:content-type:feedback-id;
 b=EY5uvsdR2zKCc1dpVmaWw+uihsSK7dojFvNpe1Ry27B48Uba5TXax3nEMQbThnY6aFg2olVwT
 4gIWSTZnPF/YUTbFMgdCEM8qENyTQMR7GlLHDg0kJ7MVZUBK8GDx6/QiiuLuXVm82WUm5BQH7YY
 rbwJAya5OO1tpjGjQGuWSSLbqsSkLuf5yPu7SDrjClFMqxrNHjdnexsOxMTi3QN06gTBVp8izHN
 Ew4gCxSJzjLnYqSnsqTaQwjsRTkKYek84/8fZPIibd8XrSKAE0v2jhU7aQIg8oI/k/l/TMfw1kT
 7QAMDzCyiK6UAZfcx66aiZ3q2QumzQcK8cN59M0oPz4w==
Received: from mail2.vates.fr ([37.26.189.201] mail2.vates.fr)
 (Authenticated sender: 8631fc262581453bbf619ec5b2062170/smtp/7773de5a-2839-4720-82ee-e06722ae1d3e)
 by prod-mta-13-02.swg-srv.net (ZoneMTA - prod-mta-13) with ESMTPSA id 1a153d1b4d20008425.004
 for <linux-mm@kvack.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 19 Oct 2026 11:00:14 +0000
X-Zone-Loop: 8f3c4f4ce775af83f1766c9b3b8647a1d8ca0f81c428
x-campaign-type: default
x-transaction-id: 1143128c-92f1-41d0-aefe-952d4806faa4
x-swg-uid: 01-de76427b-9843-409d-bc8f-f6cfb01a696f
X-Mailer: Sweego
Message-ID:
 <1792407614.8631fc262581453bbf619ec5b2062170.1a153d1b4d20008425@vates.tech>
x-swg-bid: 1792407614.8631fc262581453bbf619ec5b2062170.1a153d1b4d20008425
Feedback-ID: default:8631fc262581453bbf619ec5b2062170:Sweego
x-campaign-id: default
x-client-id: 8631fc262581453bbf619ec5b2062170
X-Originating-IP: [37.26.189.201]
Received: from localhost.localdomain (88-188-240-210.subs.proxad.net [88.188.240.210])
	(Authenticated sender: teddy.astie)
	by mail2.vates.fr (Postfix) with ESMTPSA id 8A21181CCC;
	Mon, 19 Oct 2026 13:00:13 +0200 (CEST)
From: Teddy Astie <teddy.astie@vates.tech>
To: linux-kernel@vger.kernel.org
Cc: Teddy Astie <teddy.astie@vates.tech>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	linux-mm@kvack.org
Subject: [PATCH] percpu: Define DECLARE_PER_CPU_DECRYPTED when !CONFIG_AMD_MEM_ENCRYPT
Date: Mon, 19 Oct 2026 12:58:45 +0200
MIME-Version: 1.0
X-BM-Disclaimer: Yes
Content-Type: multipart/alternative; boundary="-=Part.32d.1ca226132b300a39.1a153d1b114.f3da98e4d88fa494=-"
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1792407613721
X-Stat-Signature: hac5otsf4b8wtnxeori1f789ut7pijzy
X-Rspamd-Queue-Id: 7059FC0003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792407619-124722
X-HE-Meta: U2FsdGVkX19yw/ic72tMvvBcelwQNBpE/Ycsdet8T/8MVbNE/yIVDfiXITUzZTjXw1eIQiaLqgMeqtFm5CltJpPKkr0rHd1ZFS0aoEkJ3jwtj4CGd5m00bG/8c5fHMSfV9K+y5FBpea1z8lomO9UPx4cEk1KorgGQmPoOXHpMwz4UNlBuDCwAVRw78B3VPJoFfmJSHytHi5UF9b+KuX2DWAO/CVUEqbs7lV4S/6nOwdVz6aKpc8RWS3WGK+8RybDBNo43C1q1TmI7Sy246K6Oxf7KfiXHk3ahnMq9LbIoGsBQhl3zgJxhOixrg09fMYb30rY7Lw+wk02onka/rF9kAq1sYASiVGtJIJnXt01VnBfFrMEEoMpbTAFWhPC+3zjXshwU+QF7Jt/KrBJuabbaT2SUrZ49eJD9G5cZEWrCpENLS32jsJWpKAhRgdCSw+4Wa4QEG8GsB2IRzFEyT54T0YzUBUtaViT7/ylr37lH2GuyF6MCnw8nyo7zehs6JGxXgU3fNJE7oh6Dh5Pv8CPABdE1pPkaYocrDRYXEr57/7mN0tkHQ7p0fpQcHIJWjZjdeDn7/1n3JV15iqcN/ZC0wCmP/qViIsryqrDiRawsZUXVyOPdYZDBkSnX3m2n+WkT/De1HeQKimTSdPS9XDe+MEBUNgyw3zSo91bxpYOpb+RoqLF9kTr7mxirHARXz71Yp2Yw4HT1NV1DjDw5Cwaul9IvL8yODhCpJ867+YAfTRnHoWufRTcHHmBJ7mr2yBy8AWZl7vtUDgRcGSkHMsm1fkhVEaOx6UIveuQCXDp4+OJSzWYy4vOzL0qubgl5AI7PDh3zFdAt2ESCR8qahpzkIsvbrvHTS5IPcHXNvFrndHSF1+ySj7hU76EW9XW0eCzntDUxWwK3bNm2U4hY7AheGxaC0yAuKpsieYns8IWAuI2GUiRAQuEW0MHYiZ6XZOHtbk5yzIjfG6bx1Fazkl
 VcMCUPMh
 pNsvwd7+ws6PXJaHgICkvSnxaaUmzuLKKQiQfVMdOhxq6GOLRqeV0l7mFu4hRhkgDkdb5gKYyJEFa/D28XEBBHEuVuq0i2z6UDi8DxHZnyc3HWJ2vhi21axK0SovcyhrPR+Q3VPR5LAqnZDEbSm12BzRvNhA04GdN1PTmoaXszgqqBHoKNERyOQDzIBJjjROupPD8Am3kbKKQd0yrBnIDEESdavzSG34uYD48fiCH+TDxLMifyfihaIMAGln/c5EJIvJCFdttMTtRk25zQSCvpube4hmhsC8lQQtquyM0pC+Doj8lE6s67jLjwo16vRShBgQuRXrp1DVfEY0BgEmGf1WZO8S2i//HtMZU3YKGURNXXRbAc19xXA1uA0ndFdwDf5O+cvO+T0jQ3AD1/4myNDPYF9obznejBFDclLvrKsF4tKtcizCaDTxBYvxsIGYh6kBOOhCK5CZhrQnOvmGwqhtY/ifeGuRoJDM1+JVFwk1Lx96rk5hRXOYgfifrLs6qQuu+uyFbjemmbtl1ybSmf+yyxTpzeXH1bu+Aho+lk+X95AFFfyj1PViOd4lj8IRtxwgrJ2ohv6dpvL9QoZVx3YZdpRRVAykDV+TO75sWFqaBIMqfS+zF6vBv3qqVD21otlTpwCuZ1MCaDyqhHPsKU1YnAl0l2H9PC8hXJC+nLk5BbTValNmeibuZzZSRC3Ev7n+z0L/Vh1eD7ZLQhyB2afUMyzlp8ZzPd430ohl+TIlyKZsG7xJZ1WwSZHKgkhjq9WUt+/Rc+6dOAecbAPBm7G/WvgUc2vc9cFN5mRG46XPWMFd01n99uyQrkpqxJ2wVWNFHQz7uVKKxS+/DkVIp7tQqYg5QbBU8wOGvCH6Ul+cw/TtLPNHYYY+K6X8SmpVzCj3y54f5+Ro4/fNLo47qfiaXBE7VMezrWBEWcXEsr6arbOQoA/RYP/fAYp2cNn+qlg1pqGBFOp///t2Q8z22YqFRl5QI
 BcmjSsmr
 CNzqzPIBx1ni7CrS2cJe438UX4C7m7gDxYUmHHrpl7kuMI2IMJu9BEpWWqV+cPorzhIIczSBaS211UqRt9YnOn3PB+7x1GPO9jUkDrvIIvAwtumO3JRaap1++Nhia1jzH9CLi9nlnJedQmHqgfj80UBo1Eou+NAMVX8BXAPTcc480HUbQZ/Ver8r/kW1JmkD87VBhU9A+rZ4lbhyD+0K9JjvUTHiAoUCczR0OdbqnRYU8CeP9aRvgEZmzvPtIEVM3Fs10sSvwWiHlDtC31GZEKx533YgBD6E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

---=Part.32d.1ca226132b300a39.1a153d1b114.f3da98e4d88fa494=-
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

When CONFIG_AMD_MEM_ENCRYPT is compiled out, DECLARE_PER_CPU_DECRYPTED
appears to be missing (even though DEFINE_PER_CPU_DECRYPTED is defined)=2E

Signed-off-by: Teddy Astie <teddy=2Eastie@vates=2Etech>
---
CC: Dennis Zhou <dennis@kernel=2Eorg>
CC: Tejun Heo <tj@kernel=2Eorg>
CC: Christoph Lameter <cl@gentwo=2Eorg>
CC: linux-mm@kvack=2Eorg

 include/linux/percpu-defs=2Eh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/percpu-defs=2Eh b/include/linux/percpu-defs=2Eh
index 43c854a273c3=2E=2E1f838183c3f4 100644
--- a/include/linux/percpu-defs=2Eh
+++ b/include/linux/percpu-defs=2Eh
@@ -184,6 +184,7 @@
 #define DEFINE_PER_CPU_DECRYPTED(type, name)				\
 	DEFINE_PER_CPU_SECTION(type, name, "=2E=2Edecrypted")
 #else
+#define DECLARE_PER_CPU_DECRYPTED(type, name) DECLARE_PER_CPU(type, name)
 #define DEFINE_PER_CPU_DECRYPTED(type, name)	DEFINE_PER_CPU(type, name)
 #endif
=20
--=20
2=2E56=2E0



-- 
Teddy Astie | Vates XCP-ng Developer

XCP-ng & Xen Orchestra - Vates s=
olutions

web: https://vates=2Etech
---=Part.32d.1ca226132b300a39.1a153d1b114.f3da98e4d88fa494=---

