Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 740FE606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 18:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z7H5836/
Received: by kanga.kvack.org (Postfix)
	id 8DC6C6B00EF; Sun, 15 Nov 2026 13:28:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D1D6B05B0; Sun, 15 Nov 2026 13:28:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A35B6B05B1; Sun, 15 Nov 2026 13:28:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 565EB6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 13:28:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D87271407DA
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:28:18 +0000 (UTC)
X-FDA: 85438188276.05.78B3B65
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 066BA40007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:28:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="z7H5836/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794767297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2sqyuT4GDnGp9+dHpDjnGTvZCe15TFZq/xtAkotKkE=;
	b=Sp4jH0Ikex9+bO/xq4ZtKhYivtajEXLeQDqDUqiftU2lbaU73OeIetCKHgu7rZjCdfW+KQ
	mHCZ4o/U7I7qNiE/XuTDDZS+zpEy8BGRi3nAaaKvdvGYcMfuNoNyXFAbKvtPFVF6INY7rk
	Z14qYh0f12O+3Q9RMEsXh8USGjrhhFg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="z7H5836/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794767297;
	b=AbyfhJ/ZzKMNYqCnS43pNQTey7auqwFaNFsWcuGbOzHafaLX6rnssKQBbtg3u+mvBiOlmF
	sPoEPClQRc0HdD0+cfSwT774yzbjoQfQazvyXuqCKhUio2RwOa7TVoaqst2ru4HINrg/pq
	nD2fCqCuuQ53ZiuXOkadNLm/d9Ku0MI=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8b29b83fdf1so1344665b3a.2
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794767296; x=1795372096; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:from
         :subject:cc:to:message-id:date:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S2sqyuT4GDnGp9+dHpDjnGTvZCe15TFZq/xtAkotKkE=;
        b=z7H5836/wYZ3OW1AL0HquIE4+CBE3yf33vlLrVq1Wd2EdzRDe3BVzJGhAwhLaH9DTw
         PRojraZcVHifGlS/gvQwYbLfEMuhZlVNMMLeG9zGpunMtVBOzajPJ67B58Etj7YiaJMa
         xQw25xRTH46doZ8y2wTNiSD0ezttmlZ1YNdYSViUrZiF1FGmmNKgS0ZYoHtfiTYzlMnI
         oVmWhwVfYpKapUM0fCb2LZtCQMbvOMHdf4Ft/GzLv8hg1WCv3KfLR9kL3aWeD07aFRPc
         lTJqCAmAgJJ6EGrzV8Ur8wA0xC/OeI+xOcbtuhKgYPJBxx54vQ75I+4T8SobxUqF2j30
         e9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794767296; x=1795372096;
        h=mime-version:content-transfer-encoding:references:in-reply-to:from
         :subject:cc:to:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S2sqyuT4GDnGp9+dHpDjnGTvZCe15TFZq/xtAkotKkE=;
        b=EmrJ6zd4ohOtbYCASQIx5EtQmq+b2FzSlZx5RKMRnpcCAnHsWmOhmag387fc/+mIHC
         7HbOssvGLNsqesc2pP0K5Q/XRxzyCKnsbmH07DCWm1gOnkH4bSqqORBbgW7IBBESSpWo
         VujRrWshVHwp1TmUwOe2oL3WqdgYpozHzQ9Xg4Kkq240UL6brP5jfDt81pX5chB+3nM4
         4S1ikxayIMI14QRh9kjDsgIn3ZC8/3T0radCKVAjNxx5CdQkJBL6NbCfmFqKaVl07fC1
         owCRRX3jIDgWvDTST1k2irJNlJtXwYZEyXfSMPNF1fGcQOjW7XTFQgFnmNqndhbfdgzD
         QHwQ==
X-Forwarded-Encrypted: i=1; AL+hErEcnQPTJoHit0aTed8HietKTMmUwtBj3lH5yLVcE0eN5Wh7H7njepMXamtBzflGb3LLPErg3lQBHg==@kvack.org
X-Gm-Message-State: APuU4Z+ISshBSWVZveYILppbXCg3GqP+a/rfeQVz9IehL9U+vDoacU+C
	PQk/WKKUMTQ/rExlfhIjmrrIWzSx+0tZ0DemOfkWUb8A+Paivug+3rSz
X-Gm-Gg: AYBFou3fmCzeay2IjJc/23uWA3Fzh/Ibg5nvvBbnAeKPMpx7uAp0BUbltBfw+NDufm7
	t5w5B6Xzp9D42BypdjzxtAp7pS7A80DvBS1YRrYQwymsg9XP6WCgzpLzi9g05PKQDiHibYL66mz
	kJHj7oxSLQNtSdARFvY1tGEQVHQmvesSY4lYUodhaHxJVLG+iYWd733jL/bD3ELH9WPVzCdUUA5
	gTWaqpMpyj4SfddbrdOb0B0/by2V13fmtoegSJHHUdHytjTiet5Ov57xgMwRU8qxVDFkkGPFuLr
	Yn3jIR6HsuQS6vyElwS/qxGSPzvSXjRLs1IxViui34y78TKo6v70/JJXgVgZ5m1zMEVv9uCPrcZ
	GVtVJfJP2mBpFrxIgJauAD5+G8qH0K2sL9CzFDUblZpodAxPDP/WPa/KipcyV4GbxZWH7WOY5o6
	Yy9qyQv5GCCPNtsJyN/p6eNJVBB3hGdY4Rgz6Tw5mLPFJ+7r9HSGt31RruNfSDNXeD52g6NMVqG
	APet77UpmuJBCzKw7/0kaF7JihY5ZtA3i94FWOo7Wp5S/z5LyXHxzIJFCiS/I70R0UFyp8uUSog
	FH8/zdXDi9mbhEJhm0XbK9iNMJ4SwBlsiyTyiUvf+5nnEb9n9sQdJa9t9AHzlJkM1kHfJDGJCsC
	b3M7joKcI8AbAienBU3PbkjIlQQJ2IlkgLA==
X-Received: by 2002:a05:6a00:230c:b0:89f:d620:226 with SMTP id d2e1a72fcca58-8beb619bec4mr7100607b3a.24.1794767295502;
        Sun, 15 Nov 2026 10:28:15 -0800 (PST)
Received: from localhost ([153.61.198.242])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bececcce6bsm2804318b3a.1.2026.11.15.10.28.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Nov 2026 10:28:14 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Sun, 15 Nov 2026 18:28:14 +0000
Message-Id: <DMVZWOMFDBX6.3HVETC9L8RUEU@gmail.com>
To: "Christian Brauner" <brauner@kernel.org>, "Amir Goldstein"
 <amir73il@gmail.com>, <linux-fsdevel@vger.kernel.org>
Cc: "Chris Down" <chris@chrisdown.name>, "Miklos Szeredi"
 <mszeredi@redhat.com>, <linux-unionfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-trace-kernel@vger.kernel.org>, <linux-integrity@vger.kernel.org>,
 <linux-security-module@vger.kernel.org>, <linux-mm@kvack.org>,
 <stable@vger.kernel.org>, "Sashiko" <sashiko-bot@kernel.org>
Subject: Re: [PATCH 00/13] fs: let d_real() fail
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 066BA40007
X-Stat-Signature: igqxquwbcb8cpxqcdd8b69z9ngdkz77u
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794767296-876608
X-HE-Meta: U2FsdGVkX18CoCAkVd+tSiz2R3wGGtB7s1IuyFlmEM3vvMyWEIt4Pt3vVH1FcZiarWi0AVp77cFOjb/G86WWTuy9f/2z39CRhrjN3TfdSyVDzt5g0VFvBA1Al0gn6JTXML6ENUFjiFqloOexmeR+GZLDsM08GHVoywBiykCT/jqdoTIA3skCDoK0V2hPAQabnssptQ9dDbwVzDyRk/X48n5PH/SOTQwjavD8lBWxeGvKsj77drauu/W2BqmxtazLV1KtvwBr13YGeNDNFMyj2x+nxABg+WuMTmuTRKzpPQwXW1ObVH6BsYWhSY3B0k1R6B0nxJWE3rMLXeN3xtHGMKT/uJxQwEOo09j2BjQVXoFYvIht7PS1F8ni6a+zV9b29XsHPWxRJQCuJypHifvvYvXP9edU53+PTvrbOpsB0gBmc4j04LeeTCKJEoCzyMZTCVDQoauH9Hd48jowB9kYEo8XDA6fwgMEhHVKjV7XmjAsVxQD+ZkLR9MqJBhMxDCq+nHOeLZGZwmD0Xyjt75fBZPa1iKCKbuac/V/4Dw/vN2Sdcl9uXetcNj2dB+4LkcG9RyHVAvgTmSQdvYu/hJPgRcR2hAZju9mQeUJXYsiULYYIpjZ5hLkyJk0qgUu9ffFZANLDDtkHPFSHt2ovRJsPM8NS0//9jqI/Q7T+0HBOb01Ndme6GKRc2COBjdci3tFHlU+SfqxD3xqVtS9OLcspGMMfaa+0KSkzHg6Vr0PigNhtHyWsFiYuawSX9i7d2Y9pkmupzEUA9TMULZXVRVZveyJVmBQQrhRtjNmCdXCaSuHreELmnSz4vZ3ocfU/Q/1KDAXVHjg8wnXyRtmAarDhXsRsieSBljYLuX8B4YA13A0B0j7xsoHkm35X3b9kfQh2YWciGYJSvu0/vwPE5DsJjgWb7k5Sc8uBjEb678q+sQKPEwV7Es3x4cYyxgDiGwf7YI+cqAf8lkp6vVm/D+
 BtBMtseY
 0vlVC8TRZYixqY/kCapUsRJrYHa23ohZI4MxMgo75ITrJx1W90YwL/MIjn4RypTumstEhWx69NlYDNEH1msCHo+Qix8TjV1/YlYz6k35XUzyi6ks8WXx3P1SC9D4zb/LwfnhfhkH2kNs+JAoMJBe3Gb11J9x+cbH8hPM0wPEZwaqq8kYyu+XnV1T+5JbFH7tF3+9JDj2tLuyF+e/6iK+zYfy2wAxWbf0cOGhwW6U4flL27dTqnK25MSbcHVoJACL0xbhUpkS5tq+n+VJj33YvCKlt/uaQMbesHcx7a3O9/H1rPW079u3xwrdINi2bu9dSOjoaMMN74xa4fH6wJzPIjza4gbtNeY9DmfswaCay9T+6RC5wCKfK4X5/zRpI3MlZj6HljlOoE4q7ZztauBV+VV5xaeTVvakYyA9xVG6b/+KM7hfgK5k+BPnUBsFtlhw8NRheazvmoeTVgUazmllFPZ8VIIuvHKYyy4zhMJd2AYkjF43qQWeGK/ROFmqXCG/XwWMHHoqMUrS27aifhoAnZFpFdgMeeK4IiTFrdVj4Q8zkHlsJd7gZWvvT5OR96el8joslotAD/vutGKK2VmN/SesxUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 06:01 AM Christian Brauner <brauner@kernel.org> wrote:
> As Amir pointed out the correct fix is to teach the callers to deal with
> an error. So d_real() may now fail for D_REAL_DATA and all callers
> handle it: uprobes fail when they're created, IMA treats it like failing
> to hash the file, IPE denies and the bpf kfunc returns NULL. Then
> d_real_inode() goes away so nobody can ignore the error again. The first
> patch only drops the WARN.

For bpf bits:
Acked-by: Alexei Starovoitov <ast@kernel.org>

