Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CAA2606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 13:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XTJ3POpp
Received: by kanga.kvack.org (Postfix)
	id 340FC6B00EF; Sun, 22 Nov 2026 08:05:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CAF96B05B0; Sun, 22 Nov 2026 08:05:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16C386B05B1; Sun, 22 Nov 2026 08:05:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4F376B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:05:20 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4BB9EA03E4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:05:20 +0000 (UTC)
X-FDA: 85462776000.06.7D640BD
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 626001C000A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:05:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XTJ3POpp;
	spf=pass (imf20.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795352718;
	b=FPLViZ8ikmlN6BgcItGjTCXLkq0qnOwSRK2GEK7RFoLHI9B0sqv3tCZKX8+pxEue3O7sSb
	psrYv/HUGNzibPpqac6Ru94OPy0L0ifyivCWv8ipXAjVwJKOzDhX5nWx3OKKF9GXqh+YB9
	F8s0b7g5bv/3RgN9ANDyDZ6v/bca37U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795352718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWrKfPGF7LOPwjmyteayfnOd6ieu3Oe0BV/YoOgWcuE=;
	b=KfSiyRHztYkxZpW9vIr1MeDbd8pQ/npNXqCO0REUIsNecFpahjw6/2nHCFyRp7eTktrPxm
	P1sPnRZuG6O9mSBUGn8Uoc6+7o/atROZhfXDWSjKlLNye3ya/HO/SZzTvIzsQU9LMJQZT0
	c7kf0oEL36h5t7KatUldWzbB7htpKzc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XTJ3POpp;
	spf=pass (imf20.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so28505735e9.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 05:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795352717; x=1795957517; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hWrKfPGF7LOPwjmyteayfnOd6ieu3Oe0BV/YoOgWcuE=;
        b=XTJ3POpp95VB8xHxEhcK82/9mQUmZxatLbIttEm8apTLukxGHu6JvWiZD+qiMX03FX
         PpKajmmkNYnSSLNEOK5Ygjr02moxxle7jGJfoKO4jlZKXE3S0TIh42IT/o9FjaObeupy
         wrlGJEQiIkRzvDdNrBHz4lWT35KSRyCzoKun6FlqXJYAaUVXPVO21ieLbJ1BN05oDUYh
         JdhnxdfuerRixcWMZh/rgAgw3cj82QhNOFXvK3y4crT03CrO89UGDNUP1V9oPjL5Msd1
         7a0CL6Ty3VRmrDqU71nhjeLAM7SKrRjKjYuV7ZHFzZaoINWHop+7dkXp+95gaIwZmaB5
         WlHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795352717; x=1795957517;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hWrKfPGF7LOPwjmyteayfnOd6ieu3Oe0BV/YoOgWcuE=;
        b=Sc67xWA6LS7y06I0vFQLk9/U3wEHuP9BY49fTvT41YGtwWm/ndrYuKO3XpHFpmHARy
         j8UxXrUj/Ur2CP53VkTJKNPQAZG14fn0nI0FdWcdH7RvCX/m63foLsC1/auifb6YeJo/
         YAox+KY8pDEnoBtyEJBaoRkUMqaixasOhAbq5PYVZEfcsZ/ZefN1sK1gR1iAeMaGrWCc
         znXqY9raf1MbaEmu3urOsUtqovnJ4KsLiMfk6SV31bg9w6cNm0f6n+IvaFlXG3dXmRzZ
         SP+ybdJEvojdZPxgKyexcaVSFiU3GNgRhg9aOxISxYyueIcnj9YaD6Dwr/N9JJqDUSRT
         E//Q==
X-Forwarded-Encrypted: i=1; AL+hErEwSq5MB98b6PiCzRvapbcnXZIP5nBCN5+1mdJKgQTaLYYbUQqNFrqTH7P1Io7okLNK4qLWTC1Sfw==@kvack.org
X-Gm-Message-State: APuU4Z+2QAqBPq5grZaXb2NRXXXZEJlFxafzcLQ25BLURTLIF8+XoYe1
	UtvbBM+oCm/F+I52PtK4Rt5BpxBw2btwTEs6IQHDfQBO0vo/GwSZMJ3/
X-Gm-Gg: AZFdTZf2eD8SsIlLJUPsswPvi322NQmW2Uioi97qXrBCF0bsnAy7Gz7adY4JKbVzFMo
	EsmIT0gSMkAE28a2gjBXY0JkCLQycbmczcaNhA8tJ7R/jANJOS4+EuXgssMo3+Zt6/JTxdiURv9
	g8FHh7ao7zzzaLFUEfawZHlam7RkUDs8geuwkGnjmJcDOYYIdAIXI/7CeHlv0Gclo47IA2Cbe5J
	SGyhH1zvEL5ano0RkWqUKP4QEp9LerofRH3dFpaJt8YwJE144A+9p9IGmQnyuFYL76kYTNNMhlQ
	qArAjJxwpG0Fo2QLcWrqfUKcovDY2HyGdybiDDa16KRYMIQcd9Bxh556h342lYPosuwK9TDFpdG
	5MXb+WzMWsxLHWdpFsAW8z8y9fJ7JzxZPCwq5m2gTXRzg62IaJW1iEAPS8rpGXa5sMQtXOPHv/7
	sHlGNTw8RtBwkw0GwgNbOzgeWX/vjbx6AABU8y72jYIdcJANmLVnWSahWuUAdd9L2/L3xneM7qB
	Y6mVKWllxp1PJRPrhhwfq6O9QZyR/1DmEvkdaG6ALsIPl+VVxSpFXxw6y0CKVBxFN1rYhOvigy9
	xOpyAK6xZJzrzMuSEK3G3pyf
X-Received: by 2002:a7b:c4d2:0:b0:4a1:d291:d863 with SMTP id 5b1f17b1804b1-4bb861394f1mr160871155e9.4.1795352716633;
        Sun, 22 Nov 2026 05:05:16 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab9cf005f2sm13317236f8f.45.2026.11.22.05.05.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 05:05:16 -0800 (PST)
Message-ID: <5f0dc94b-af96-437f-afc4-cd36d8b1a249@gmail.com>
Date: Sun, 22 Nov 2026 14:05:14 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/list_lru: fix potential infinite loop on xa node
 allocation failure
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>,
 linux-mm@kvack.org, stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
References: <20261122031143.3639941-1-songmuchun@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261122031143.3639941-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 626001C000A
X-Stat-Signature: jbqqzqppmrhk3axhimurc3f4oh3ae3bi
X-Rspam-User:
X-HE-Tag: 1795352718-867794
X-HE-Meta: U2FsdGVkX19GuKP4aWGzaFugUd86+CDuUkYDavU0sGpZmgxptd4OpHkPPLSeeuWbVwIiDM26sV0n7+jkvflZrWLUASNp4JF9A0OSctQXlpSvrbOvk5uh03bgazdZnWdptlIb/s/lgyjC3EmK1vVzd4lsiyIBR0CnGhEsgPHlH6OwP1yNGrzCzLDFd+MB9fPC3EbslOOzLhZIYrLk+fpt5gu+yYpJUK1NiCSl7tu6FnRsjwSKnCxbcKy2jQ6gGo3JVud0X3oQsxVCoAe1lUQL6Y6cVYilYazvgPcXcI/Nkn1hzN6Jz3iT6YimwdsrlDXes9kovZM3zmqR9T6ecF6pGMTNYc/X8Q+EgS8e1tjU9/x6oYnSXMNYGPe74EjG8kzADizzrnpmRdewJKlCyLwKDoRw3ort1IRaIR83fa7xpA0ccQPYv09ajdPkwRmLxdXW7hs5Ye1xo0fL6VI4QmOBLE31YI54TpUjsVFBErWPakZf4Hmd7AayYK6pkHDPbKS4RSnQokUbbfbKgOOGdzmXU+JRy1cTS9+lCetc6YTPdwvVDzGi2a17JBqHUuNQdpAGbH90ram91R/kCpp0cICTJFXrf0tlEda17SUlDSSnSjRbe9JHc1lPPEm7ORUS/7nZlcZY1CWdZtg5uqwz1S/oObQUhclF2lx+t1Fg0/DRR4S9F1aWoyAj4MtcNRugj4Y/g1PVw1dCVD0iw44po9D31JQAwZqIqmynCBatr7pGDBbPShDcSmGNAfDO3WuKZN+T2nhOmO+P56OZZ97V+4ta6zIQYueIvPWtYT2kmxUF+l+vSakO0fyR6KpVLn2WMdTaesNZsMUamxTZ9TQ51P6z50DM9AYEzmdfNgR1f+VyPAcJ3CWLYinRMUAqXDWXAmcH+JUptOKtVz8sE0a9oPNeOgzf17FH1pi+sO99q3FT5LyGCV0YdzA/Nsf+/KwfoPAAOz4xrkZwXJ/QDzK0Yk1
 eoqh+KXu
 xYmLeR9ApQ/NvdAXl13P1ck4B8t+DuSzl/xwtuzFXk+za1P57voUX4vjkymtmMlOqmw2grzs9P0YmpVYUIKmoS5HLQl1BTYksreNE2mr/zAy4vtfhsVgugRytOB9IqTtXqK+ssBnNmxuTqPS4/6PK6Joi8hp0otaRJy+23dPfcHWqXDSEB0NJreAdLknYrqDuWA0Zx+/FNtoFR3tJbUCNohwBRAqYRKgruXd1p4+VOqGez9vufD/95vyhKoIx3fgSjbs1PwFp+CTKmRxahw7xutCb8FpKZmcibJf3AX4I+7q0mZrYkaq39rAxNyYdRG3MrrXNUc0zowvJdoA4lTngQNOwNarOSCBV4H9jxgbyPScm4EDoG9B2dWzqUYm7GSAhQekeRZcZARYVQlqkWnvyt1obVKYKZm0F+3o1AuQShCPO3vjH5nwX/8Hjsuvzvvm7hY5SJlnFTRiQOvByutXQZFIAHyecvhzEooIiZQtCadKKEvpdz2WBWMNPMSL/q3GEBag3KMG6EAW9XbIuRe1XEP28IwvIaTfSemYy9Iljhy9WhxKYggqAH6oiwkXmwxTqaHN1deXaR0CCKr+M11VEWOuRPylPQ8D3/ELjA/r0RsIvTvmDaXTS1qd+6HjAl3WUPexGodBGvgjcGHhgUW9C5ETjpSj75j/QWO6oqDBWxzTblr3VJSY+FQzt/5q4ydU8tRwhI1pJoXYcMXK6/2/iOQVGhIdu+ZFdYkHsM+3oUetNiPnkZMvUbGHwn2MUciVRpZYSSFH4FV+inPL194YSQkrvPBzuJIHuJrtLYiTHAcYZ3sJtO5zkhC3qDBBZ2RTC6S+QmFOGHazGoMc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/22/26 4:11 AM, Muchun Song wrote:
> __memcg_list_lru_alloc() populates missing list_lru_memcg entries
> top-down, from the farthest unpopulated ancestor down to @memcg.  When
> storing the entry for an ancestor (pos != memcg) needs a new xa_node,
> xas_store() sets XA_ERROR(-ENOMEM) and leaves @pos unpopulated.  If the
> following xas_nomem() also fails to allocate, the inner loop exits with
> the error still set, but the outer loop ignores it and reruns on the same
> unpopulated ancestor: xas_set() then resets the state to XAS_RESTART and
> retries the store.  A one-off failure is recovered on that retry, but as
> long as the allocation keeps failing, e.g. under sustained memory
> pressure, the loop makes no progress and, with no schedule point, becomes
> an RCU stall / hard lockup when the caller holds mapping->i_pages.xa_lock
> with IRQs disabled.
> 
> Stop the outer walk when xas_error() is set so the existing cleanup frees
> @mlru and the error is propagated to the caller.
> 
> Fixes: 28e98022b31e ("mm/list_lru: simplify reparenting and initial allocation")
> Cc: stable@vger.kernel.org
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/bug/linux-21c1dba9-8d6f-4368-b38b-9a57cacb056f
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

