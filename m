Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A32A606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=efz5zOli
Received: by kanga.kvack.org (Postfix)
	id 7428D6B05B2; Wed, 11 Nov 2026 10:44:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71AFC6B05B3; Wed, 11 Nov 2026 10:44:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630EA6B05B4; Wed, 11 Nov 2026 10:44:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 45CD16B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:44:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D320AC031D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:44:40 +0000 (UTC)
X-FDA: 85423260720.26.098655A
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0143120002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:44:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=efz5zOli;
	spf=pass (imf13.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794411879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JW9NRbd1yObMC6jDLBg/nqkiPWQhNDyNhJfsXYnn4pU=;
	b=bcfoae/JI1DhIGDnGSD4T2NGYt+vlecYKArcAvq6qxv5tB/HoBW6UwaB8W9l+otFRxY30H
	1e00Y6qiFggMuJjRk3a9RXQ+zYIlfjPwHWz4CnIZZ8fs03dGhpDtUvl/+HzFFP/YBbXuNs
	O5hJ0N6Zar+74VpePrEJFr45fByHlUg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794411879;
	b=jl36tlAavV61T1wiWqqprf0moe3VAIChOq5ZqbtTimyWEOV8poYyL1p0uBh6+ltJBHJWVK
	5z5k1fTAWI4WbAf4JDLJo07A5qGh6F70XBC80DkUQqlomF2TYDNJM6xVi9BAe8p7vMBzOx
	ghvptYuNjBu+jYSrL7sBUOdwmSEPPpc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=efz5zOli;
	spf=pass (imf13.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cdd9e925075so525101a12.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794411878; x=1795016678; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:cc:to
         :from:subject:message-id:date:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JW9NRbd1yObMC6jDLBg/nqkiPWQhNDyNhJfsXYnn4pU=;
        b=efz5zOlixRPlpf7ERaUb1x4IpMlYbVRnzdRyIps0Q/26dgB9nyTZbntjqH53kR//ma
         gdUKsjr5063GJXT2doZ34zjAUlIEuI6i/fZ+L2/QVlmJ1N4TsY1vPotxqzHKIRS8vmgy
         u0SppZuDl2rIWJ03TMETKLDt9ClgBLJAutJI/CeZ7JEvY85HbKauhsG/wiA1lLRI73sl
         5Wgh1hmKwWeF1NAKzApDlxnA+D4A/Hd8sa9UqtdfT+l4q1962qNPJcVNi7FLEddsDfd1
         7mkAcl3FWZvfQegPk5/FtNDJIxJbvzzyp2h1Aki9UN5aTj0nWf/wMpmrd++XbTisw6WO
         OuNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794411878; x=1795016678;
        h=mime-version:content-transfer-encoding:references:in-reply-to:cc:to
         :from:subject:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JW9NRbd1yObMC6jDLBg/nqkiPWQhNDyNhJfsXYnn4pU=;
        b=wodTGB85VWiWdSJlYeKfmGeCNfyY4AQ6dXK2PujmnishQMAtW6HCR8F9RViAvA6Ioa
         ZZ95MZQlUm2asuhJ/KWN3JUuNzBLYL7Hql1MO1H5DqsPfgzjLPOb0sUs8ij0xrPd6WMf
         nDBu8wiLUrTPnCYWFVOa9WpOjwqYW+ZrlTNnipCldkeVptCRL1Qyyc5EkS0pbHDcOlFG
         f8FRhQQrWEULiG6gHqjCcxW9hPZdXZi/SO06wPNDL6FmdB8y1j81jRxIfx2T+QyjEFzk
         Gmdu7FGwsuMkDCz2Wf+MCLPFhb0yTD98eDo3qaCannSb4/6bqUOwecs9NhjX9CMmyCtg
         d+ng==
X-Forwarded-Encrypted: i=1; AL+hErHMEa6z8p7UzQC/wRj+PdtZpkVI4VIDNSW8q/TxUwZYz4rQLSiUGSU0asygA+zlkTE0E41fsOF7Xw==@kvack.org
X-Gm-Message-State: APuU4Z/27rNLHSsIsE+eVtGb0WuJhAJHDsi1gmK2HUUC5sAg3tEOLU8g
	4cpZPHPJhdJqmjUqRO8mZ0LiaqvWX7TvPkmS+pQdqaZ2RFWPxRfTTjrg
X-Gm-Gg: AYBFou2LxnHOm0k16OFnsNGGeBsjyMecIYph5ma+3rBpgRANvzJSPvTmrWDDwWlq8jT
	SE8kWfxG8hl3J14yB4PY2kYuSaNzSzrcE7fTP8fw6JRo/4vXemepdARXgHATPIwe51rmToBlUjL
	wd1poCzODqeEOwdykp6P6CyQiamxWyhs2xhAcpkUwL7GuU0/Gm7W0YXue6qVGdp05DwlMXinF2x
	v87RkUEKwIGCRxlyK9u5fLDscxk152XD6asR278LIfrC97wLv8uL2MYocshuQpR9QuDeoHiLLcD
	Q/p/XUJt1NrOF68Vj0rzh9KCXgJxisBiET6tX3XhuuGNDw6//NNjCvNqzqoJTONnKRxpqJQ+Gmg
	eo+kzeqGhQgtPJaNpznM8+G5wj8/MIxUfJqjD96PGf4CtzyRkN8589CXndkVt0nXnZz64hgNnWs
	sMZLumz7Qusr6bmY3E7k+v/YbqI7IFMJEpYuv6zjMaU+l/TDelzrOLxIEct69twf29qMKg6lU+Y
	sdFQkE1J2afxn9JJeAn1y6lgVlG8khBLbZ0+LXJDAuQObT1w0LiIIlMIrIBleFntWpqO1CsDsWt
	tTnk8kNMv+1vZqsNm3dQ2yJy9lpAbz4iwCsZwrPJ1TRLQ8nRz9wAOPDbNAWKCLuTXUzOlvzKsae
	SyTBEjbAvxRDEXluXUdXWrvqogoG9kPyWFoPqffPHmbsxrVtLlQRh3i0f
X-Received: by 2002:a17:90b:4c82:b0:3ac:8446:c1a5 with SMTP id 98e67ed59e1d1-3b182f253e0mr2786337a91.48.1794411877445;
        Wed, 11 Nov 2026 07:44:37 -0800 (PST)
Received: from localhost ([153.61.198.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b18142fa70sm4663040a91.16.2026.11.11.07.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 07:44:36 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Nov 2026 15:44:36 +0000
Message-Id: <DMSHX7SU7M9U.2YBBRPD8DYGWN@gmail.com>
Subject: Re: [PATCH] mm/bpf: Add bpf_mem_cgroup_memory_events_local() kfunc
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Hongfu Li" <hongfu.li@linux.dev>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "JP Kobryn" <jp.kobryn@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: <bpf@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, "Hongfu Li" <lihongfu@kylinos.cn>
In-Reply-To: <20261111-for-bpf_memctl-1111-v1-1-8b56784d9e5a@kylinos.cn>
References: <20261111-for-bpf_memctl-1111-v1-1-8b56784d9e5a@kylinos.cn>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam06
X-Stat-Signature: 9e3x5nmi1c8btjdar4b9yqgp18bhfuci
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0143120002
X-Rspam-User: 
X-HE-Tag: 1794411878-438972
X-HE-Meta: U2FsdGVkX1/VgnuepzqgZXfX/ANPApU6t7qWydtefp0CN+D/cVgfXSnQ9DQLj2R1FWikDDNke9NzaKEp+YLJFtfTJcIONrC5RjzdBAEh31DT+64MOKTifbLFJ+X20WBnpjJdnbyo6aM30PdgIXp9hsaiBbOvXH/z40Ih3wejwX1Hjn1IxtiVleY42WMDTEbCifituPg+9qTBhH4q0r71oW7Iv7XJZOHrdPidvc/5Tl9tlRE6sojHsXweZkTgbtK4ycbZQDnkCSxOlcyeBnXO4RBwr1RrKOBtsW1nC0Es0YQhYMdf7RQ98AtvQp3Lnk978Py3s7n/iUIF2SQ1Y2rpQFhfZCcafthQC3ZMed2s7aNGHBQnUl2fyc/I0DB0agstdR7jO99YKL4flb6q5O0bqogHJ9075/b9l1hl6WcK0A1ktg+TqD7lesiR+a1f8RLhhCG9Ix5hvGncLc8IRS/vKoPhFdYx6wxfLHEDssZMFHWvf6DmoR/levlHDOIW7Qp2X1M/G68juPKqZNXk+IBayGhJ6P31jZXR/LRxtSXSMbsltIgwsHQzmb/i+1MQNfVBAlkBz6vCTyNe24D7KzS0LVRxQ03YoqoSaI5Bpor8+66UPtc9uHVF1m2QEzDPfWxCpyg2k5yMBkVmYrn84z7FVHaNhjdLbYMNP3DHJ1vpOSUKlj2kPVw9dxIfg8dLJRWEV0VxER7fOSm7GASUk9nG1tKrYRJNbDzluSduJZsioj7zEWZuAMfVPLSZ3JmDgxC6VafpGA2oxj5qfjghes029H/cCcO8tiTOo08eP0zmzlWwOaqPlK/FjRVfrribh4gGlYb0MYTEnNE2Ze6+uPa/927YC4zgeOyMULw0Hq+peLLP3MraPUJSXbqsHWEz1sotsz51jFf6ghn8UsR+9qWC4/Y7pbSv/6nGq41jmU32XLY54gZo2nxCN1NRaDJU6N9a1fOiRtuA9nouyw/ylEX
 chXCar3X
 mZOTm4nKMSm5EYYTGd3DtS1YT+LAwio/6Np6TE2EKUAnc7z1lDGY/ntWTV3R6YPONPzp3mm4NW6JgDGoIVO2p4TZcLFiDerGvhA++ivX43DUKlBg5JGQt5aHn+8h0kZY4P8cfykdyvJ9kaN7Adnc/GJxWHLePuv9VAdMGOs4sMq0TOuwjMVFE7JC/BIM4BY9SN/MhmIJOFlgY62Q3Lr6KfPT7UgkHyWg7VJCMySmmwQM4tK+t8Yo1ij7A6xYVznSFJQtcSCinvtwlL3FRtldUwvT7Ym99cotkVxfJXtFkW75ebOXN/gV/iCsJhD4RqMYcSpeY7xDuUE5c/oHS/OGJgfG+YmITlyIoI+P2eUOFj4rYiHb/RuNwXrUdlOJB3MlJMBD4zeykLxFKZEyiA6KVo9NP9KPrGsA/ObLx0PMR+2AVBUm4dz8nKscCwH/TV6hecOZnmqkiFve58nppI6hMF/ggcj+da9vh8mL/U9N9VsCswtnLZ3ObT1NNKYtQTZ3CcmUacMnt/Ea8wN7Eal7E9dDqT+7Mcxq0s2GBpvTr7Ez5NuDNXifEqxaI+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:56 PM Hongfu Li <hongfu.li@linux.dev> wrote:
> Expose the local counters to BPF programs with a kfunc, so that a
> policy can attribute events to a specific cgroup instead of only
> seeing the aggregate of the subtree.

No. The prog can do it today without a new kfunc:

  memcg = bpf_get_mem_cgroup(css);
  if (!memcg)
          return 0;
  cnt = memcg->memory_events_local[MEMCG_OOM_KILL].counter;
  bpf_put_mem_cgroup(memcg);

memcg is a trusted pointer to a struct that is in BTF.

pw-bot: cr

