Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E8D2CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78EE16B0005; Tue,  5 May 2026 11:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 764C36B0088; Tue,  5 May 2026 11:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67A6C6B008A; Tue,  5 May 2026 11:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 57F9C6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:37:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DEA251A051E
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:37:05 +0000 (UTC)
X-FDA: 84733769610.06.D2E57F4
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 01C91140014
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:37:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yj3Krorf;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Xp95Do87GefisQWCOnrXqWboy1FPW36B7zu3IiHqEM=;
	b=QT9XueoIqB6F8gAW+CD1UEQsLRBLoIHQaSbbGJmFBHfDYot07Y9vovGo5pTdPaIdLKAlLq
	pSF9iqkJa90xNntlJkgVqeO+E3TT+m9i1aYmJbugcCUyZTTqOnv29lni3F5915ZblJibaq
	UXA1q1z3RtB51oS+QiYqdhfhJyJsDEw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yj3Krorf;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995424; a=rsa-sha256;
	cv=none;
	b=5aijEIsmsSe92u333QEafi8g6yRRqPBwyBomjo4tf9ozSZDB3eAvV+aZj3c4YPxrDDyZ5r
	TGwGyCzFUk4AUoXtMWWakjBTEMIylY61U9SYiaqDy5K1P5to8AFXx1oMmsJKHZ8DeELXGJ
	c52nokYpkSocCS8XouuEa34Jzj0eB7A=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8d7e7f48499so567119985a.1
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777995423; x=1778600223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Xp95Do87GefisQWCOnrXqWboy1FPW36B7zu3IiHqEM=;
        b=Yj3Krorfvc4gLizQiGreMFtGvq9NamnFyJqql2CSKm6gOFZq/jqVmDuqvxi+6CSe/h
         6RL5xz//l/UgGyiPGVXIwF8BqWlErjy2KtzBTpZSqoe7dQCSOHnLVDeOGyHA/uhPgGW2
         uOpyQGX1D/PQxIqRlXg+rmVdFH63owlr0igAjRmoQIMBLRFocM3EOqqFIQfTMKSJNAz5
         1UtGn8NrJHCKN5Edi6RkVvz3dVXS7J9WGaYNvXCj2/AxU56uoypWI33zDqcl1whPDNK0
         3kl0YOA/BzgNDu+p2rt6tSLVpRW1k5+HvBu49YodNsWWCE8BO3KhOA/c8lKTeJV6C6Hr
         wQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995423; x=1778600223;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4Xp95Do87GefisQWCOnrXqWboy1FPW36B7zu3IiHqEM=;
        b=TO1hreuNDPH1Tz3QkwZjYWZ7kPH/uHGE81iw09AGgxgudJwJ+MByvlHS/XSAfYheR4
         o0pGLqDrKQAp3X619ALHpgUNiX+foYtJliyxaC7oqMlX5AVnLJWEu6KVZijWnqts+42X
         S/03nlQkj638plvSjl25ax49/paTx8jlrkI4JD0HBYC2igRseAyaxhU+ijFwXG457AVd
         p5M/+dBj5sNFEMdLt3g0cLhfuLbqbEwBdWXJ+1NKc6MsCJ0OHswLI+klV07mursf2yXM
         H5xUzsX44oY5v3/wu1j01vu3beR+mk1q1kLat1L7kilm4LtU4XsZxre/HmAaND0X6bZ7
         BbSA==
X-Gm-Message-State: AOJu0Yw5CXuZln+KaJ6WmBNICRisaY/iWZtCBCwM4oOPd8Txt+RXcBtC
	vzp29DzahnD0+tES75Pn6fclkp5SJQ2tLQAeHzBUim5F9WflvkIXc6TPZnpHd0ediGw=
X-Gm-Gg: AeBDievua09o6XGf1LbVFEl9riz3yQUeHkY9YabboB08dp9FVgt7QacSJO/lo+VdJ7D
	OBeFuAVuAJk7iqrux4hWa81oB2V+/0v/y7K9g5rLxOXYuxxbrH9Va0iX6d7Hwhmsl7XVOSJ1GvH
	mjFbRrhFSc1/HFCMUC2I0aJKUz5JbYsirKNypCFX/tSJw9vs6TQ+QQ1v0UcDIPatw8gIWTvfovx
	Iv7nBtNOuM3xNhC+4pvc6uWFEDTtdD+qJjAsEmdBgO4F02dXR7KpTKYheiFQTMWF/IbqbacN+ma
	ngMRZ2pUDSOgHYWhmevQOO2F5bQ99ZxTfXjt+A2J02mTr6yTKCBDDymQog+ziFRgCCrfKFokMqb
	Y1XnhTzizgW2XsxBo9UkZJbKBzcF2O/GGBhpQnB5m3Ppy2Icyypl3A9dKxHvTuQPVj082BjPS3i
	y/gZ5eBwi7clmjWvOZ3HZr1VeUHRAWF/w5SN3mUVlcXf4sZ+pQ2dpgk7bwc0RFmkiMuiwV7Ps=
X-Received: by 2002:a05:620a:4591:b0:8e4:ebbb:b162 with SMTP id af79cd13be357-8fd15ada964mr2204638085a.9.1777995422947;
        Tue, 05 May 2026 08:37:02 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2c91fb3bsm1350515585a.41.2026.05.05.08.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:37:02 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jeff Xu <jeffxu@google.com>, 
 Kees Cook <kees@kernel.org>, Pratyush Yadav <pratyush@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Brendan Jackman <jackmanb@google.com>, Greg Thelen <gthelen@google.com>, 
 stable@vger.kernel.org
In-Reply-To: <20260505133922.797635-1-pratyush@kernel.org>
References: <20260505133922.797635-1-pratyush@kernel.org>
Subject: Re: [PATCH] memfd: deny writeable mappings when implying
 SEAL_WRITE
Message-Id: <177799542165.635180.17809433268620237886.b4-ty@soleen.com>
Date: Tue, 05 May 2026 15:37:01 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Stat-Signature: qg5e1bfpczjotwgbk6tjf9ij773tia71
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 01C91140014
X-Rspam-User: 
X-HE-Tag: 1777995423-549009
X-HE-Meta: U2FsdGVkX19r2sIHitkCEYk0DTLvksqX7pfA9I14Y+NvCjMnOoc9D0rpwT6YVyUEo85WQcpP56F29ZSloalA4d8okBqBRijfQVYzO6l+anr2Ib3eijyptuP/i1TSpY6e01gIywyyMj5RnmO7leY9fhr/x5MNxQfFRaPzE51oXDduABQDkjPRTx4B/PZO9LGeiuIUSJhCfRJW7Cq1cENDFlQk+wPNtWbDoBkT4ATfIa3XiajDzhL6cstsF6iiY0JwbQFTf/4euDPHUUHFafms3BDFHttyLDNWZ7GqMz41tR/AW3bD/sJ6obN2LSHQKcWhy5G/47JODuIrqIwn43EBJ3XLEflbKS/d/5j64THo68Ii9sp2FaI9p9ar38B3U+Y8kdgEy9PwyQkrkF5hrbhKMMW7y3YgSGaHCqsiMTXk6FbJ6gHlbclGuim4jqBUXPQ1Nu3Ek447bRbEb0RWV8HN7z1mfvmK+JZix9TDauZzojxzFuEarvJRgSCAGnzX5wqjepZZR6wNw6YroeLgeDbZA318bD1Uv4N9kicRJnBS8V0mE3Yu6TrcoMEnCZjpS7uAWbfiT/uVOkyfEIvfTn2oXeIlCbbNT3BiQxPC3zT+9TtCqQEgHmc26mdj/NEv/9HiyLEP9QA8+5QCGqm2qfZ8AG7TV+b6rqVPZ00VlbFx55HTw1RRxeoI1J9fV2aSOaDM8ddkdC8CSBZ0ASg+JtGOZ1UDnyaTpn/bdAvH5Jw8xc4e7jiOcOnXONNjlFtnFAL1dGyq6lR8vktDDdUkWSvZjOFgDRAWudwHmNZY4/Nv7BCKjHnnV9BT8on8H8DBDLJRIR27/Eo5yjkFahE5gE6LkdwajwT9+quhkqW/DthrJSV6q3aUa7CoUlVY+rUjZ1jo24gAPXa7NPPxDoOSoUNdcRS/5Cc4CoSFwqDAdeMylejKN5gWgtPq8iL1UqAl32CxNy7S8uEqa1dxXQBPZ7+
 KkkWTOGB
 DAhj+VJloj0+LQPa19vR81pnJjzL7GAwMslGV0I7TMSfyp104f+2P+w9QUV9zuKodmOSJ6XvMms2Io4dM5aBLhZP8B94tyqhbFm9XwooE9kJktOnFuciA2HT+VanpP0WytBNPoHf/W80RKMxErfGgZMsJNlS7erOm8OZsfJZeczCgnEdMTf9r48o9xi/YXuyOAFfnDrGg84WQpAfINaXMphjiP4ol6/eoVgPpawXh2Wjw2Yb7RCJLFnWme3DjE4avZxCWCsqHYOWL7C/mNeHxNbWoQ8ip9AzXVgNZxOuZXXdAaa+iUEzO4xwNmPKsGnTifIl0g4v0v5J22oVrQ2GYx9esELdZdGR41Dpj5/Hp4HLbcMrPMftN56JjZOcDfK/U0UMM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, 05 May 2026 15:39:20 +0200, Pratyush Yadav wrote:
> When SEAL_EXEC is added, SEAL_WRITE is implied to make W^X. But the
> implied seal is set after the check that makes sure the memfd can not
> have any writable mappings. This means one can use SEAL_EXEC to apply
> SEAL_WRITE while having writeable mappings.
> 
> This breaks the contract that SEAL_WRITE provides and can be used by an
> attacker to pass a memfd that appears to be write sealed but can still
> be modified arbitrarily.
> 
> [...]

Applied, thanks!

[1/1] memfd: deny writeable mappings when implying SEAL_WRITE
      commit: 73f496662a9848021e75742a69a3239ea850c3ee

Best regards,
-- 
Pasha Tatashin <pasha.tatashin@soleen.com>


