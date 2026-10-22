Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9679D606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 08:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=d4slDfi6
Received: by kanga.kvack.org (Postfix)
	id A327B6B08DC; Thu, 22 Oct 2026 04:38:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3526B08DD; Thu, 22 Oct 2026 04:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2AA6B08DE; Thu, 22 Oct 2026 04:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BDD06B08DC
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:38:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9334A8424
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:38:32 +0000 (UTC)
X-FDA: 85349610864.09.2BED7E4
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id 19520180003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:38:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d4slDfi6;
	spf=pass (imf24.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792658311;
	b=3CxeEkdGtsKuzzpCd7j5LnoxUFy4EC11D/+Qcy61/38e3tzdeY3TZdouZBYWmihu77eIEW
	8/wExP3lTJ61B1sRkI/Ur1KacEIuiLJZ7irXdOEo6iV4qughTwvER3nqjBQGKVRWGuwHPT
	XaHLTqz9tZ6lZ3Rz/vtKAB6sXieH68o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d4slDfi6;
	spf=pass (imf24.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792658311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dkcN82wBwExuVJyyVBnWtTmTYSL00fmUHuQKj+lYVsk=;
	b=YoUZXgvtIZIlbXg94u3tp7+V0NzwxPvfbOA2SFzMjuzO/dV6pbpW/MUPzgWWd9HBBP7W4B
	QxroEFcsXmTm157Q8hYsFt45l4W0qdbhsmvW24VpTehC0mZJBQIL1Qy/fdIc8ovK/zLWni
	PjrRxULr6COIY1XftJyQZ8iWXZSAdJc=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48e011d370dso1233431f8f.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792658310; x=1793263110; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dkcN82wBwExuVJyyVBnWtTmTYSL00fmUHuQKj+lYVsk=;
        b=d4slDfi6mdnhNYOAkM/T2e0MzgeAv/FQ+sxGv3X8vdN2jVdm3WCuvI33Z95nfee8EU
         tTs5CbujlOuqf4AYFcmy8P0JwWudyy6vKTx4w1fQCJOqO+B++P5gUVvJnsKsyrXfnvLQ
         tE4Ewy77Y/QmpzKrceiNMj2eiMhbV8XhMxKYaTSygahVnlINOnp8eNsTMvgLfPK/d10u
         PpgtSQPJb0IgeH7G/4juLEII828KQeH4XUQUagFyMNvxrI8sZI+AgB/IkQr1uweHzo36
         1ghjJB1ixy/PM/eznKuAuLTMR2oQQoDiIT6V+mbNX+S2G42chGXBCwfmEWgTI/CjfUX4
         ZCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792658310; x=1793263110;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dkcN82wBwExuVJyyVBnWtTmTYSL00fmUHuQKj+lYVsk=;
        b=O1fo5ZG8oaweSeYUQqk5CdY7JIvHoHOb7vsGny3l3yB8fXssM6EMcfPsIC+AR6Skyw
         K/kdfRki5F5fFP4gQ1cvfYN6yHkvPdd3hzpOx7kZzom6ukxdn0TfkUxKurVoRg4IQNaQ
         7gLmE+ngwub370VZSEBp2CisJsvq2kunEV5YEejZfbatZeN3ftU416bDU2miK2yEIbCl
         rZR/jXqWbj1QB4fuPDbzheb+T9GGrUl804HyKX/vNQ6KOe0lK4C5Qh7Oz42517091gY7
         aVJTOcawFB3HUU6jFYPEGLV0nNB9V2fgeyoiQ38VMZRyu5FZEtHACBak6FaKewnEPibP
         vMFg==
X-Gm-Message-State: AFq9FYL/za2q2CLExoeWO9KdYh5gENjxZHwtGsJMbp4zEoXDNiwg5om9
	cHn7x0FrUoEnYk1pkODgnp4R1o/iPVWCc1VcGsrYgCYPnMQXCHxM2twv
X-Gm-Gg: AYBFou3q7/Fg6A+rlaRFVBUwMXub4b3M0EGFdmUyydWVJU9nD9F6VFaCsqms7v0Nqkl
	V8EA2jF44MH9pq/Xcl+ji27BR56KnByKhVE3lt8FM1H8pIftNA/rS9PIeU4hfYQfqbzUMUr2mNy
	RllI2RUEZxgupKxb0Kfy9iMWlAiQQ+QOTTgfXOvpHpGcJbhhCxSWzjJV2EwUbNCyaVh9Sp11fP9
	wkAApcgyEnvGZsR8lPcg0MYqNmIBFcilWStuVJaGq1fH/WUXGr3CRwHGaNohIitsC/WfMlpcvhD
	6As1R5u0zU/OfE64h3fHUp6H1WOvg4Lcl7NaAIz0O6X/S5EbTgvZ88sFVRNATVlijx+yP4GenU8
	e40qgK0ob8D7v3JzM5YSwvISQzc+aB4wGg/TE6tvD6151vHW8ugCz14Feuk1hZerfzH1BBFAxy8
	vvXMcjAFNDaOzHQeBZYx/C8Hf93Jp7LfJdck7KKHW2B48u/N5Mpx3EegnSTOivWrhYzuW5Wh02W
	k3l9Jtfv7gbyOpVard3buquweUaHewlMyd+M0nbP3RXhzOKlmpAjRjom+VQejsdfwlUaY9V
X-Received: by 2002:a05:6000:2504:b0:489:bc38:9438 with SMTP id ffacd0b85a97d-48e26494161mr9445159f8f.29.1792658309636;
        Thu, 22 Oct 2026 01:38:29 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828e72sm10155819f8f.26.2026.10.22.01.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 01:38:29 -0700 (PDT)
Message-ID: <2f3e24cf-a09a-4355-a342-5eba8573d78c@gmail.com>
Date: Thu, 22 Oct 2026 10:38:28 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm: hugetlb: track CMA reservations by pool
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, david@kernel.org,
 osalvador@suse.de, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1792651104.git.zhengqi.arch@bytedance.com>
 <29b35f7221c30f1dfa320a933f6095f37b612a37.1792651104.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <29b35f7221c30f1dfa320a933f6095f37b612a37.1792651104.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 19520180003
X-Stat-Signature: i53khqjittg9kj38f8171qzryb8reagr
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792658310-652273
X-HE-Meta: U2FsdGVkX18494GuPbyjnStMODXm9uOGr5uvqYOqEsmgoQF/yu/rP/5ftZZJkkE7CIIsPUIpu919TRGws8aGiISDbHatLW3pvbN70ASHbDm+UX8ThG9PR+TE7tJ++V/OCjABobCndj0HP5G7hrMed0Uy/XTKAb7taS/GSjF4aI509APuzQEwtZykKX2EE+npPTRNOhrr/gEMBbYVQ09DCV2V9Wp3KL7xBpmIFweZOYNlQ9B1s5wMijgbA+u9SXdWmfVJSOfX6Uhdv7JFsbLCTTEkEOT1cLSagAegxNFCMswvAWl2F6eXyDn6TJIYRiQQZ5WEwTXJSVfFn8XEfjoG+meAhh0OqmHBBQcCoC3JSWET9HMmd9A1kcPTUOl6RBicvQQ943QPbtWlwo85s5ypuz1tkUGFoi18Xnac+1I4EwecHuuw4exdPpvgzPgogiM5+9QVjJ9clL4jDH0hr7EcFrHBNyMGELhWtWqzCNvN+F6lIBGnxByTTN2eBmjZWGbzLiESKTsv7AYsA89W57MshF9KjXMkX76oTEa6Rvt/k3hwEtTLu+vhrCG7btMO+KJe+V3BOGeJtSti9axiasmbCk1wfgpOfKr8qc/S3S94sRR7unv3orBfZJGhr2kIbLldzS7jznxYoV/RY+ZKcgi/OUWaVez/SeQysiD0IleWAFt+y0GxgnSxklqQtwi5KTMxpx7fCNtHDTVP3rgx06h9WjoAUbRFBSenKFo8q0E7OeIcBxTCIslkwlAyo0yaK9p1/gQtBK1lyEh9pcBbA7twcFQpwHkHKwGvLN928tJvzz0vnyCa2UjeZGt+pyBdirzRL2mHwPywa/pOohGigGSOG4qP7j1YmBPvBXOE1KbNGHb3zw+2OnCPkwhKT0CntJFLRvdpgaIrlvP8KzzpthSkDRu64EcN1fJxAAoDZMcpdui+cRW9gqlmbirAlt1LGso2VdPDz33G9dSv9x3w7Ci
 2W9AotS+
 +ks/Gx8TfDBrqV4pgvRUnaFQFN8VnrSLdx6bDSP4O1gZncJTTeC3Ie7yzexnn5ZnoKJzGDUzhZZqbeDSuQwipJu3cij3okf5b2i7F2zvil0+S89Ik+KrWbva1DZiDcTloYmckzHJb4uLuKjmHkrrFxkamCkO3JsnogttTVQVlf12cyVCV86SmCGQ/W4V8sivT0rzFB+F52ryfjWsRR7JCEJ6mEVOqKv24cMcLLJvY6QblEO3QEBJS+41fEapxiWN2e1+evw+Mo9xaZS9vJGY/jspu/2M5LeqpxnT8tIemfEiNnyr4uKNM/Kavac0aZcmy7sCLzykeza54epvC8v9W66sgmNfZJnvuyo2SvNjxhrFtjKY8JfqszYWGUlI+MIEgnQBjNK5E72TsHGdY5W/MTjhB+j3uDMvkxwopCVPB94P5LMYTIOxHNmoDCbX9XCV8tA9tTlIzJAdT5DYgbAyStbq6OYaxLv4GOUIo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/22/26 9:31 AM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Introduce fixed default and PMD pool slots in preparation for PMD-sized
> HugeTLB CMA support. Continue accepting only the architecture's existing
> CMA page size and keep all gigantic sizes sharing the default pool.
> PMD-sized pool support will be added in a subsequent patch.
> 
> Select the pool for allocation, CMA-only checks and boot-time accounting.
> Release folios through the CMA area that owns their physical memory,
> including after demotion.
> 
> Record each pool's successfully reserved capacity and remove
> hugetlb_cma_validate_params(), since the per-pool CMA-only check handles
> missing or empty reservations.
> 
> Assisted-by: LLM
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
LGTM so:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

