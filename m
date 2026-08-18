Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3494FC5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 08:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287616B03F6; Tue, 18 Aug 2026 04:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25F6B6B077E; Tue, 18 Aug 2026 04:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E9A6B0788; Tue, 18 Aug 2026 04:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF96A6B03F6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:25:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F2931C1F4E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:25:15 +0000 (UTC)
X-FDA: 85113705390.28.066781A
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id A800114000B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:25:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="D4HYT//V";
	spf=pass (imf26.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787041513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MoKxMu3trW179Mtx8T4bCvrDvhYRCia9C6wY8DzRR0g=;
	b=bSL36Oaq96et/3tn7jWN2qfaLo8TjBXTQ8AXqX+EcRB37AUVF8rIc+cYWpik1d5NEFseI4
	zJqaLDAegP0qBvFnPo9YngMJUnDs2p4cG5I+riAL/svZWcX+Z5jX8Wv153/Py6TON6nazz
	boBMsDmG8UvGSy8LWRFCwi9dxavBjzk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="D4HYT//V";
	spf=pass (imf26.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787041513;
	b=13L2QF4GSRPmqydBonql1yy90EXjFMAWTLeOndpjOYZ/PfUxi0zQ1S6FEAsyi6SZfagxpr
	1jQT3x1XtG8vbRalBrXsYb5/KI0lRvtLIUYlZBTJboDg7n7eU1qZu3guc/gkhvik/HQ9sf
	3PHYegWDEyAq0SseXyaAdj6bfH9e5O0=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493b966dd74so29003745e9.3
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787041512; x=1787646312; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MoKxMu3trW179Mtx8T4bCvrDvhYRCia9C6wY8DzRR0g=;
        b=D4HYT//VtJZ1adFF2VZzjlejk/H0tSF9YaPPuVZgISqgVjEF0OtK9DUc+gZHFDplGY
         2Wff/K6FDxHiaL+CXkgyGBDB8tTbNjbK7wxvNj5fL+M6D0pm3c5IZv+7MKE9odBXbDUT
         4XLTIdfch5IBOlUb7cYpa9nTENCx/X7kHUVpl5BGzJYqt9VIubS0nL2m23JHzMOPrSwA
         t1pi0JKDF27K3JXI31S6qt11di3qwvObxj7dy0xlRN/DNsVGZeYmQNJYcIRYd0VSUG5W
         717ZnXnaLin2ZdtLkw5hdFs7sJCfxD9vN4gnkJ2/Jys3f2H6LUaNBpMQXwM4xXhieYLT
         aMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787041512; x=1787646312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MoKxMu3trW179Mtx8T4bCvrDvhYRCia9C6wY8DzRR0g=;
        b=RdV+bzJbmYe2MDJoNR4gN68Tp/iAvNUnBDHPhTP4txbMNi9AbwWyJultPnTnYFq+qN
         qW9i4prQK6Snte6+aW+B7Hwo5r/WozEnIyrE/yu+nFpT0Qvv5GCze2OwaPrGc2LoRuX7
         H2Y4S0rdo4iHI05Gn1bpdfoRpbbK0wzOnbm9TEf0FMA/WPoQNb7n3fZrHV8pCKAz61v+
         pBzy4mjCobwStUP/S0BM1vagFDwVgFLESNRQ/VI8EbTTLdEg0ExHSMxqr7TeIkGPEdSa
         PtRebEM3E1vB0/fyPnIcZR4tAeQGhMN6pb/4jr09iboUc+gEJEnsyo8avab7x4EovEvA
         MUaQ==
X-Forwarded-Encrypted: i=1; AHgh+Ros/kZ+WCg4xXklUXlFdxMnnCReQXaXFZUelSgAqJagVN2U46PfMf22FTXBWZD2Qe6exhUwITbb3A==@kvack.org
X-Gm-Message-State: AOJu0YzJyZ3aze1dWqUsaBwpMERFd5cDYkQVVpzreUvg9upmOfUmr38T
	Wn5WiX9hXMUjmfVYSIbZuJpUeEGM6nE+B6zX6ulWPwwG4HPUyTsoPWdu
X-Gm-Gg: AR+sD10Wb3lEAo1u1lju9Q+y4XWSRqZya9YQ70O+q0Ff3D1i1nK75UrSOJZFqQfDNJi
	4HoBt3C86REP7RxoKl7sSqZ96R9z50iZfQsSz/brdLHlevVRVDl93j0u7+DDnbpJzU6K3v9NC81
	oTKwoPRalqhVrsrUmxWUXc2ajJkSxngrDHtcQTTpL7q3xZiqwKNu9aMD+UH5oSvpXVyo14kdVi3
	cn7FR2vTN+PdOw0ZjR/8AJMIOzt7P1PdmRnKuMYUkQd7zLz5PrdnMH5YyAAPOXFfzEk6Sy5wAu5
	rKGbaqWtzXyszgWhVtyjIPcvirZwfSFMYHpeJAySq7GSciU13Xc2dayYu1OrkUhf8NGW28xO5d8
	qm254G0WbTdLCvvSN+m4z951QKC8T17OZYbqagd9Y+RUNBsUk6EB7xETpZlOq/zx5iCuVSz4ktN
	xyA4IMFdOpBaCZgcc1tS3HWLm7nolbbdZpSuRpk4YHaMD+FxlADh4e3NXtqNwEA7zgUyNv4SiJf
	9t3
X-Received: by 2002:a05:600c:3f06:b0:499:484a:81d0 with SMTP id 5b1f17b1804b1-49987961c32mr517262115e9.9.1787041511977;
        Tue, 18 Aug 2026 01:25:11 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482aa084a64sm4907363f8f.17.2026.08.18.01.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 01:25:10 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: utilityemal77@gmail.com
Cc: akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	david@kernel.org,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	tasos.papagiannnis@gmail.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next 2/3] bpf: Add user memory access kfuncs for linux_binprm
Date: Tue, 18 Aug 2026 11:24:41 +0300
Message-ID: <20260818082441.4091-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <any3wCj66dWbwgwT@zenbox>
References: <any3wCj66dWbwgwT@zenbox>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A800114000B
X-Stat-Signature: f89uhf7k8khnuceopg7hhi1gdhr3ebma
X-Rspam-User: 
X-HE-Tag: 1787041513-161362
X-HE-Meta: U2FsdGVkX1/OaDcBLdurHoKlwS/9DgHrP827LeVx2DhW02dmMM+0CJ3c54DvWgtm3SQEzbPeghDpHCL5TmL3J9QCzVnVli7Y463K2GvYi/b7QN7aaX0EwxWicoVXq9K9Cexg/RlDdxlsN5qrtZ6n/bPCvaXmUkWLTPcGUBxdUg4MCaU46QLmqlIVkityBCSbgoRfuCH82hsn4Tv+QqxWxrVBT/E+BTFF5obhlYQbmKAJ26PXFDKXXmYw2qGpE0KMC+mzAFXHmSb2vAlWnpQCuJMSoIjdBgXyqYTC2ggyuth+yAN6QsNF7HFZ/DTixwI+2VDr1IscPFWfsrekNnOf72mkdP02EB5/mjNAeBQZsj1Azy7luUKWFfSUWJMa+KckJrWX0q4XYBBkPYzwV+HLvSGAPkU4JkuxDfl5tj/NoCwF12kCC/Dc2ZX8kHKjhnmAmVqTTDkWw9N94zMyyVg/mgeWu52kZD6VbwUstXFeY1fb0BBiyMKAPKS15lTDiQssIYnNSpxXgzO4DJapFQx/RHGuUnGJ6TKt6Fm/yg+hvagodCpHaKZNokt3I3Z5qE9f2xu9L2tzt85W4eeTAsXHUeKkD+swdwUMTTCJYYM4BuCuf/S3mUq6YPi9HKd3obBXvzJ2KJlir7cpdo+hetmmb0bEInaTQebxNsFupCLUysNTSSXMvtwt+PTJ25ebCip0NywT5qqKRTqQxkQRCVHQLZdXHKbNV5otHmOSBlB8vYbuIJoL4/rq78ee+oD1Nl3HoiXhjdPTp8H8UAcxUoy3sioMKN8hQ3ZhjR6Y8jcKT/HusQgkZqDF7HVkVPosHGsiqxgJHoYYOKzTyjWNSaLC3iHo+wEhSESN/0UdwWHwTJx8vGNHQGo9Wc3QKkrZZ2V7jm285b79+g+2UXUuJ6ozOUBm6JFUGUi2gXaHnR6gsQvTClvloV+SA4yf0UDxiCVVPJAIBAbeq9jpeUa4vfe
 6X/p98kJ
 rkdgcEBO3AZyNSQVkDR6zYheq75hlIMVOcQmKSO03p0PwBllJqV73+309mdtJ2hHUrGebg73u9YTbSXAxW9baEx3BA6TL5aoBjhcd1Pc4c5ocTmY4gn1YjAHxkRPMUlHUyZuHkzc6LxJDZNuL6L/3PQId+SaaIr/Ud3Wixq71vSFwKDUJCsaPjqIKgOILQBzoFBrO8HPMLJrPmQD2wXMCIsu61q5onuZyzyWlOdFsnGsDbZFRkHowKMyzNuF3lnY69I3Ks5Q2hhW5to/OrsnbamXbYI+jluLp35E/FWLizXdHxlNsu7P5gS4YW00k2EqFpiUhErpd3T4gaMfSN+08viKDTpDTacI5SpU6vgc3mLxcyMLYaYvyGLYONtRFG7xbNwPKXopJpdblqwdENNr/rq39YpS2FyRiTTU5aHpx665ql8ArwdKiBhJDMpCvvb8nv4qiUM9lc15h1AMlAtT6b3seB3ilsA2HSlXhaHzV8hhYl6UWIesUiCXiYpNJKr9iL56otI7vGHBbcDsuXkIYqD3EkDDp4X3A2u1B2y6ux+xMu8Vg7FvEzAbl/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review!

> Would it be better to handle that case transparently rather than
> requiring introducing a new kfunc / leaving that gap open for NOMMU?

> Either return an error or perform the copy from bprm->page[].

> Unless there's some reason I'm not seeing.

My understanding is that there is currently no way to use these kfuncs
on a NOMMU system. Although CONFIG_BPF_LSM does not directly depend on
CONFIG_MMU, as far as I can tell, no current NOMMU architecture provides
the required support to use them. For this reason even if I write that
code, this cannot be tested.

> It would also be better for portability across NOMMU / CONFIG_MMU
> systems (the exisiting kfunc is never registered, so a program using it
> would be rejected rather than able to handle the error).

As you suggested, I would propose to register those kfuncs
unconditionally, move the ifdefs inside those kfuncs, in the case
of NOMMU return an error (e.g. -EOPNOTSUPP) and allow the programs to
handle those.

Does this sound reasonable?

Thanks,
Anastasios

