Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA5FDF9935C
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 09:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001226B0005; Thu, 23 Apr 2026 05:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4016B008A; Thu, 23 Apr 2026 05:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE2996B008C; Thu, 23 Apr 2026 05:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC6396B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:15:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 319BB14053B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:15:37 +0000 (UTC)
X-FDA: 84689262714.27.0F81888
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4D788A0006
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:15:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bANo50Ia;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of shawdoxwu@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=shawdoxwu@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776935735; a=rsa-sha256;
	cv=none;
	b=bmgejrdk0Q11/9RUjFwVd1FZn6SEN+aG0cqeVYZWt3tlJ+UxL9T9xkT5t3sFLsJs313LBw
	q8EbYKh5AfhyIE9niBvbM2N7vsIyPNODvhn0i8Rvy9mlZRtyc56sIbNY1Z5K78QRn6Zq+0
	/MTvPswYYTnho0qKlhBkqKfyU0ZBLfk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bANo50Ia;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of shawdoxwu@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=shawdoxwu@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776935735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=/sHEpv/1qXsMJgP6KklqXPkz0wDWe4Z9dTmnatzra1I=;
	b=A6gk+ODEujlnOdNQLdCEV8PwpJLTfMSxtaygonFSXWW9DciUlOp/5dumRtvOLINCnCXdWP
	A1o7N7Dk//d0az2Y/itrgFIskMsrYbwSwdky1CQPifjkO1VxE6n5sX89ux1p51+uUYYATE
	fOx8w8Opt1fy7KsaNfGjbywekmENoy0=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ad21f437eeso42030355ad.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776935734; x=1777540534; darn=kvack.org;
        h=content-transfer-encoding:mime-version:in-reply-to:organization
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/sHEpv/1qXsMJgP6KklqXPkz0wDWe4Z9dTmnatzra1I=;
        b=bANo50IalV5maObDlWyfFuvkJwEFLIOHO5FAdDyvt2z3kGGgN/5bXiROSNb/pCMaH7
         CtE/ljCk3TzhFzfqH9pkJv6NH4YPCa7TtUvcZQj//d/r/skevBfyteR53gFHxrpWUs+G
         X/ogbVx+XM16E7n3zrhrqyN4b7oS0ziS1akivmCCR3Ecu3Uj7oyGZcdcKrdLsupgTi7B
         0ebbQktVd+d8e19tS+Cgfl9G2EYxoKF9SoMe7BtlfCfZf45T+ZuaF+JoVksAvvNwdOq/
         UCFnwYoO/5PXrdz59L+mfpsYty/vgotgJukywnNjKWXBXObzNTpLh4bd+1dJb82YfTl/
         Lr5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776935734; x=1777540534;
        h=content-transfer-encoding:mime-version:in-reply-to:organization
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/sHEpv/1qXsMJgP6KklqXPkz0wDWe4Z9dTmnatzra1I=;
        b=XYtnJ+/DxEgYi71EGPwd8qspN6NS0EeOFyQHKhHemzDOrE9dQsJElln84D/ok2wTd6
         fIKMfZmQEHSF+PUKrc3v/eoK+Qz/vVUWREKmbIEROr1daPm2G/W0B6yR4WrdCooYRkWG
         DnNiSXP2PW1I1py472wGfYr4q5OqHOdXQCMZ1Prcge4McU0sCTbd2Dw2DHh2N6GZvK3c
         ZFKa1sXMzgHTZLtTcvAxS7QUvmJzJKDtx9quSC1X2OJzHbZDn7EfZmyXtsIsAee3+Lrt
         P+09oDTakSrWH9G8Zrt0/ksVuGHI6D83pWZgGISuMyFTJF5jVo/LEX6g5x8JZekhz3wR
         miXw==
X-Forwarded-Encrypted: i=1; AFNElJ/P9AZbjn5DOVowVB/XdRaQiI7TXJOk20dOvPoMtxtuhF5BOvdGdKy+NX+cKCjPrA3a1gnVX0VT2g==@kvack.org
X-Gm-Message-State: AOJu0YzmCCgK5hcA1McfdCOQduEygxJhDOu4ExK/sBllVkWunEnY9sxs
	7qfqI+/a7siIR2FdlCm9ylb3x0LnqLRG4DOOOexoFzwm876ZbSIXPvj1
X-Gm-Gg: AeBDieuNB10QwnkBGQ55jVOXWHA8R+72y6ZYaITQy/sd0z+3lDzbXlxYPjinJJtWUmh
	prdVhTgpGecONgNOhRizClYxljHCwxuiRlK5+khgF2Ff1+aM0pN2e3HD4mnh5ULuq8ZZyoVixx7
	Q61HxL9D7pWVm1gJtrUF2JzrktTUj2pwdRVIhfMvnQkeaYO+QBOxrklQVluyqcA2VSDfZwBDfBR
	4ioLKUBt3jX89Qyz+oPsn5uabwSrwkkYlenau59PD3YaK3f4HtSYsZ1txJET7osIOKCpMfpy5rL
	1GMGenGa1h1vp9LPphP+0F5Iww8Obnclw6OEGQKdVNngGvfGzoQugLCjDZa/odJ/bPa/siO21JD
	nH0JCV+CaoqfsC+Oa83aA5rKPlCPELTN+K+vszx1CrE1zjsowSFME1BizzXGb/KzAeR3AdTjDLn
	8l4PQDflM++q58Fjc97FegQjCb8Ua/QgtLtMMeaugv25nGTY0Fvz0BYaPf4n2ncN40Uw==
X-Received: by 2002:a17:902:aa96:b0:2b7:86be:7670 with SMTP id d9443c01a7336-2b786be7763mr67586695ad.19.1776935733936;
        Thu, 23 Apr 2026 02:15:33 -0700 (PDT)
Received: from localhost (vpngw1.cse.cuhk.edu.hk. [137.189.90.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab55062sm190241795ad.84.2026.04.23.02.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 02:15:33 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:15:16 +0800
From: XIAO WU <shawdoxwu@gmail.com>
To: bot+bpf-ci@kernel.org
Cc: a.s.protopopov@gmail.com, akpm@linux-foundation.org,
 ameryhung@gmail.com, andrii@kernel.org, ast@kernel.org,
 bpf@vger.kernel.org, brauner@kernel.org, brgerst@gmail.com,
 cgroups@vger.kernel.org, chenridong@huaweicloud.com, clm@meta.com,
 daniel@iogearbox.net, davem@davemloft.net, eddyz87@gmail.com,
 geliang@kernel.org, hannes@cmpxchg.org, haoluo@google.com, hawk@kernel.org,
 hui.zhu@linux.dev, ihor.solodrai@linux.dev, inwardvessel@gmail.com,
 jeffxu@chromium.org, jiayuan.chen@linux.dev, john.fastabend@gmail.com,
 jolsa@kernel.org, kees@kernel.org, kernel@jfarr.cc,
 kerneljasonxing@gmail.com, kpsingh@kernel.org, kuba@kernel.org,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, martin.lau@kernel.org,
 martin.lau@linux.dev, masahiroy@kernel.org, mhocko@kernel.org,
 mkoutny@suse.com, muchun.song@linux.dev, nathan@kernel.org,
 netdev@vger.kernel.org, ojeda@kernel.org, paul.chaignon@gmail.com,
 peterz@infradead.org, rdunlap@infradead.org, roman.gushchin@linux.dev,
 sdf@fomichev.me, shakeel.butt@linux.dev, shuah@kernel.org, song@kernel.org,
 tj@kernel.org, willemb@google.com, yonghong.song@linux.dev,
 zhuhui@kylinos.cn
Subject: Re: [RFC PATCH bpf-next v6 11/12] selftests/bpf: Add test for
 memcg_bpf_ops hierarchies
Message-ID: <20260423171516.00004adc@gmail.com>
Organization: CUHK
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
In-Reply-To: <958ccd923342ddd02e9122381d51319cb125ec51d601bb6fcad57531a2f5ef57@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: iy8m3cyuiqm9juey43y7bbq674614dkc
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D788A0006
X-HE-Tag: 1776935735-903832
X-HE-Meta: U2FsdGVkX18s33CrYjwHfz2ExVPwK2wQl9BjhUghdVPql/Fl699iIAuGiyY9XfdAcc3d44/MTPu6Qcnmf50pXBfLXo6GxIIx5MfpEEfOdWuI6NhSb5zvaDx0Upi14KzGYPEFNHQY/aC86laGmwofLrNUTF4xVL1mXSmH1vVSHgfBVFcKmAr98gMn5QnbyhPv7Xl/ONJxTsvnc7olQG79zyVOXimDC2s7QZrEepF/GwffDiFWgHzydk4oTG4lCLJFl3/SCE9tvED0CCfOx6eTfb1t8VWChKBd81g2pdHeGn6SrrAnhaxp+54Paxh/KZTJelAWZtMVjWjnMusD6AHunw8hsbMtjqYLa348PJukraHXgK0akL12uavVix0uEVtYO7+EDgmNGph3ag9wfUfOzgFmXmB/twVvOs3AsW9c9LTr7YRh+A85YjXFumsQ1Pcw1/fqTm4w2QBBcPoWssPUhwvfMYYad2bqaApUcCrX0iuJ0A7S2mTcszLPE9uPoktUpByB63hx+jCK4Z3/qhb7ebL2AtZQL14p86ThBvLpyKEhrjlBr4iP0iGTuOmQGLnSKPO/bSUcUEdu54QcASgVVhifrf4scn4My1speoQTztwZ8iT+2WfKDFljxE08nbJyd/nROrUlRFbQmk6Exu9fqDmYTS1kOT7POuaGl8A7OD1L9uKtS3k7EnXFWS3/tewaEhvE6q846TbTurdZer8jFI/mPbXVPTRmvzFtcnwyUup/OYUeIfHyJrAWWWUQhYXIvvxlUZgZFhjstapbbXabassIfbsN6JSpGa2AVvfaU5HSg3UcdZyh8ezjgD8slQNbLmJnOFU9eY4Ig+QBReXRiEGiLs+apEkdF5+MxxxMJ5yUYnGiemtTTOxinv8hIUt28B2ER2/9pne3z7BGoNcoACKJf/HvymN93cGih8FrGim7s43N3d6LRWzlC7JsYvEX/lqI6TkZrgNu2CX3N2B
 zLz3k0LR
 ldPPooXBSaVF/LnbGm+ge0JAwyferfcw+h0v2jRd6VlXJyfS7QWqtcqvl0aVLCWNlsjGkXRRqkS655VeXj5f+PPLe8rwmCTQ0sUS1yfTEtTU1JKUCe2phjh/52JC2gMBqCI62A3Os4cQCkWsBBLPcaZleqa4xaJSsx0Y2RZy13q9RjzbkFsvv+vBsWjMpyOjIx1fV44VJ/PxPMAeLhkUHvBOqKxp76Tj1WKBOgzcFp0gu6rTvk/brMRViLRh3kIES3Au1y6pcJldNTgIsqXV7s6TVvu2PKWEIScRCPGBKvOiItDuEEV4Cu6qjsvAwJ9Ly8ey+x+9uoJ8gWrtSaSohLzhGe240tV9ix1rW7fY63xltBnh+Eh00LpgqhQ4BZ3jdRJCYQdb8a6ZR04T+Td5qpQ5zb1lVLXlngqbCe56MnX1FfRNk6OjnDYnx73uJh1SxHoKloXC+kYoEk38Pw8fy6somBTMKM6upUY5W7suWJYbxMf0GUpHy27lWLm8iGkSmnZwXNk1UwO6HsKxiQPMDniTKtrw6aMgpLMdyul4/y13qFYTzsgN3wozTWsk06BGovjWf5ZBYvluYD7qwkYDtIEefajpU7lL43bmsZlLPgKXwCMtUAjPjap3kvegoKVTUUlGg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> +cleanup:
> +	bpf_link__destroy(link1);
> +	bpf_link__destroy(link2);
> +	bpf_link__destroy(link3);
> +	memcg_ops__detach(skel);
> +	memcg_ops__destroy(skel);
>
> Can this crash if skel is NULL?

Yes, this is a valid bug in the selftest cleanup path.

If execution jumps to cleanup before memcg_ops__open_and_load()
succeeds, skel remains NULL. In that case, memcg_ops__detach(skel)
dereferences NULL through obj->skeleton in the generated detach helper,
as you pointed out.

This is also inconsistent with nearby tests in the same file that
already do if (skel) {
    memcg_ops__detach(skel);
    memcg_ops__destroy(skel);
}

The C repro, modeling the same control flow:

--8<--
// SPDX-License-Identifier: GPL-2.0
// PoC for cleanup-path NULL dereference in
test_memcg_ops_hierarchies().

#include <stdio.h>

struct bpf_object_skeleton {
    int dummy;
};

struct memcg_ops {
    struct bpf_object_skeleton *skeleton;
};

__attribute__((noinline))
static void bpf_object__detach_skeleton(struct bpf_object_skeleton *s)
{
    (void)s;
}

/* Matches generated skeleton helper shape from review mail. */
static inline void memcg_ops__detach(struct memcg_ops *obj)
{
    bpf_object__detach_skeleton(obj->skeleton);
}

static int setup_cgroup_environment_fail(void)
{
    return -1;
}

int main(void)
{
    int ret;
    struct memcg_ops *skel = NULL;

    fprintf(stderr, "[*] trigger cleanup with skel == NULL\n");

    /* Simulate early failure before open_and_load() assigns skel. */
    ret = setup_cgroup_environment_fail();
    if (ret)
        goto cleanup;

cleanup:
    /* Same problematic call pattern as in the test cleanup block. */
    memcg_ops__detach(skel);

    return 0;
}
--8<--


Signed-off-by: XIAO WU <shawdoxwu@gmail.com>

Thanks,

xiao

