Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB271CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 09:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7F86B002A; Fri, 28 Nov 2025 04:24:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78A06B002F; Fri, 28 Nov 2025 04:24:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E7E6B0030; Fri, 28 Nov 2025 04:24:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C78D86B002A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:24:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78AB159242
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:24:19 +0000 (UTC)
X-FDA: 84159479838.27.3D450EA
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id C0DC840010
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:24:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f6zc8WUd;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764321857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ED9nuiaO8n6F6aMYH2jutdJWyKTjRdS1+Fiwm5emSdo=;
	b=objkcKzSs5Rd/265I9boMajslpFrg8ImZ/ZRXAhZ6KE63GOFLW4hWIid+bc61JShyMuytr
	CkTPVxQaV0tWhWhPagn4DJuxsy2S2FpNk7Nz0bhl5ftBlRZBbzfRocAIAOyllJ00OBvIzL
	e582JNGiy19ptM3x3G/YMcuYiWSjQp4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764321857; a=rsa-sha256;
	cv=none;
	b=SLo7t9EKkrrR7eLnjjU4PgNu5OxYOSn8QnJC/1kEdNbrLYdpBPGEJQ0Xj6bOrD+tV2VrRL
	6m/v/zEnDoazbrJi6nLT0yoWsEvwJWR2yCbQZn7Lht3X8n77gfZMWEyOY6hh5VPqX/YD4F
	sFxECBDSZlXAsEVB0zYdBo+/c2XxLZM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f6zc8WUd;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2958db8ae4fso16844325ad.2
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 01:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764321856; x=1764926656; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ED9nuiaO8n6F6aMYH2jutdJWyKTjRdS1+Fiwm5emSdo=;
        b=f6zc8WUd+OgTTwLrLj+F2xVKYbCI9gCSvaALVFwMqrVDmuDXg86/13YWFfdqY48s5x
         PkhBTMHuBv+nzUA159HmFaxNYgt+6/4xd7sLzTTD+d7X9s7kj/vrXvwhIvqpeLhn+vrQ
         0ZmUcXlOnP1iLWm2hm6yY6qE/z8u0POoYTi4SXMibxtpg2zT9NcMx74mfc+NiQfO4Rki
         nojhuJLPhaNz/wzZw871qcbLupTfUR/DNITdUkHNybkTN6SpC1njcad4IioPVXGcQ2MJ
         q8TrvMPJU+8XkbT3SGhRoPR3Rb2kqxduduESFcgpc8uT1TnzPm7hl9Go7FV6nDozgVnF
         zu/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764321856; x=1764926656;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ED9nuiaO8n6F6aMYH2jutdJWyKTjRdS1+Fiwm5emSdo=;
        b=DCTFoNx+1ZQqvdfUQZv3g+08RvKkORWebhEe3P4z4ehJrXOWioeI3jfXxuqLqQkpdO
         t1VE7KGhNiUVfvJCNV0pnEqD3399OK9SY71yQ5b4Y8SRLFem0oEYDJTPgPYqpSCNSFuD
         NUHe42WUOY6WFVxK1T3ap6syRaf04j44sKLZlHSIwPAyJSm3aCPMXHv6tkO4if3S5uwD
         jUs0Ge74uvQDu2iAorvru6FmeEIuzQtHINJnGNsaJThw4VZbToUs1qt2cvNAYoTJaAaj
         VsFqdAOcxhp4s5zFKXK7MV0Eog6KU5fiGd7LuNn83NTTi40i+sMGoy1kxCLKdxrV8Ao9
         3aMw==
X-Gm-Message-State: AOJu0YzCP69h6UZLsA+3kIp4jS5pgQyLULAXZX2DYoq4j6oSptak5zl2
	qU6yAlqxAt7z02q6tqV14ZdtLqdD9p6NzzFWdx2KC13l8cCr+MoDQc3b
X-Gm-Gg: ASbGncvE3jyfHTOMG25plVGIjiSeLqoaHaPW1FHf+Ye0r2Acq8WavS0lEfwkC7V1/h2
	J12jlcIvCdax3RA1NZLyzDoXNbwMqb2BCbf90L86IYeuR1uV2dWBZOD9kdq27ULCAjlBDOMEC3q
	KqWA/vn5wNE4oY65tkL6BdQS4HqNhO/wYh7BBOhkw6pdDJSuO6w6jkpL5jn2M71+be732FOJLYY
	L0nBBSs9PE4il7WLNMEy5VyOEm1a5SjFvXALLeKwY19dwVFRqqHM1/npN4NmNReHaqwk0VQezea
	0xuqY75bGaT0qIYZrt7jbC/ze7UgGJxQwo5JcC8UpFQldeCkxAk+9iP+8kcoj2yyarkMI4nS8Ur
	5ZP1sDxXU7Mj3A2CeojIPPMKkAUykrzlxTiDLNd3SRMbinoljlSjYXjEgrYtoxsGjJ2HbulXMfL
	3nNaguwKMOUx8T6LdP
X-Google-Smtp-Source: AGHT+IFkvqq+4XxuQKa/k2q+LQMu+sa6LTsS3nR8WXj3JiP/G1PdBLLzpGBMoYNmd/LwjyGU4dN/Ig==
X-Received: by 2002:a17:902:e54c:b0:24c:7b94:2f53 with SMTP id d9443c01a7336-29b6c3c2913mr349029165ad.6.1764321856487;
        Fri, 28 Nov 2025 01:24:16 -0800 (PST)
Received: from dw-tp ([49.207.234.175])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce478762sm39554625ad.45.2025.11.28.01.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 01:24:15 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] powerpc/pseries/cmm: call balloon_devinfo_init() also without CONFIG_BALLOON_COMPACTION
In-Reply-To: <20251021100606.148294-2-david@redhat.com>
Date: Fri, 28 Nov 2025 14:37:28 +0530
Message-ID: <87wm3amsof.ritesh.list@gmail.com>
References: <20251021100606.148294-1-david@redhat.com> <20251021100606.148294-2-david@redhat.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C0DC840010
X-Stat-Signature: w9wm3fp71yecsj6wbissf5u9nsik7hz7
X-Rspam-User: 
X-HE-Tag: 1764321857-948016
X-HE-Meta: U2FsdGVkX1+ZJ+sYGjIvmD/4rlDM/F7iZCg4ZaEMiDDcryDordlD8n6xR8u+ZVpyhRsvaNrMq8xi9bhAVcs3h98hPiqsk/UIFb03uewO+nhHisvyOZV7HOy4rejV1Nm8FCf83yk2bAqWrcuFovK7Z7yQZ2ro5yfJA2ZqW5VEM3J0DzDqi12XSh0sWBY7piQHic7WLMjsGGKHC5NC/QLYLfySLTidlyRHsqES0vByOgVuDlHV/6RC6+hUi04DN6FHSgpu8/YbFA8Z9MMXxHpB7XKCALjgxYQuFmkxJTwXJKPhG8z1A0pHXuZlHNslyGEcizeIRlc40RvqL4MpGgsFui4fNXFqPA8XsmKZ7ffT1CoF2pDOTfax6AQFHTjoJJP1fnnqSkZ60tYtBtguoDM+woWbSKT+iomDGDWaZnMFDwMD3KL9xYf5fFx7+mt6H+PctIF6x3vk6ZxCIT3qRSLiP/KikXO87biFzcibwHS/FXA2Ng1OAw5H6AEhMXGfAtK+98H7aD+4gPU6h6eDwhVt6pymzqvQli22miGYS4WA1ckADVgsKnB+2tVRuHFxdi+AK5TNMllnLaqkErrB6JQtg/f1lMPTIUKClaiWHgXFGFvYbBacnpOcB07fvLlecWmDHcWRa+czd0QdnGnlzM2MHUdCPcSWWpI8OFvAHh+tEI3u3kPSGBMGY2F4tsXvc+MzWjBSNFjzwEixHotB19K6NOhFks9K2oTP+ISi/SVTSiLtP80UGFlPT0m1JBwlov9MxB6OmPnblhdBp4p1p66SSWSj3zNCxz1YUiYAaYYWHImDMGgxiozy6nsAc9SVTZ4dR3zbNHZKzu/3uIBPL8Bh93EWieqn9hUXIYBKPylNf+hRxlmb88+99+QP9z0Ine41yPUVNwPUbAOjqCGaLNrabqjsVrIFLaDI2qh5jT7l8E9yf5NJFf18tH1UYtFaI69AuO5v8o4hjlIxMDygptB
 hE2jKU8F
 xgq9uSOboOA0N9u/NjnmBg8Kjz2p6osetF7I4VAsDyvQAnpzviPJaS9looYbSyrZYIFfRitmazU/1D+yzL7h0ZLGEgXkTRdGAxL9GRDaLBtGUtbjxsJrWsFOV087dswxmsa1yb0GKvKtMB2E0+NdFlfGl2DiDP9fFfRIVL6K8yvqKnPt5ujCbRGHCoaby9MvndEXXpZndwUiRw6huZL8CFEY5CVWB4yuS8GWCQdBrFhXT9sLDhAJDnc+ZtN0sdntCAOKgRsbcUdYuvFV+jAZcLVcinZKGkTWJGL+uln/GAW2ckQAZxbMm1VApTZ36xd+gAb/lHr+pITpRCTdYAW2PWxenYFy6a/nr+2yrz26j7Z1pdnVJ/g9tztNNYcz3ZxAONqV4fuc+P2nShSD7DnPtfT2TwmnN2NjdVNYYjY5xzpnzYVlwHMbygT8RE5q8V57mG3v367PnFsWnlDDdhHvzTXTaNkmCU+H7L/SmXQ+agb+JnUsjQxodbExhf90UDFTUy/UK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Hildenbrand <david@redhat.com> writes:

> We always have to initialize the balloon_dev_info, even when compaction
> is not configured in: otherwise the containing list and the lock are
> left uninitialized.
>

Agreed cmm uses balloon_dev_info infrastructure beyond just
CONFIG_BALLOON_COMPACTION, so it should be initialized by default.

The patch looks good to me. Please feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

