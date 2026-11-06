Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8EF9606A90D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=y/+b9fmB
Received: by kanga.kvack.org (Postfix)
	id C9F2A6B05B3; Fri,  6 Nov 2026 04:42:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77E46B05B6; Fri,  6 Nov 2026 04:42:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B673C6B05BB; Fri,  6 Nov 2026 04:42:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F58B6B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:42:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8CC16120CA3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:42:24 +0000 (UTC)
X-FDA: 85404203808.17.62FC687
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id ADF84120007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:42:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="y/+b9fmB";
	spf=pass (imf29.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793958142;
	b=j35sEXYBTeUdiPfKkKszvr2os5PCCjnjXd/83aCO+pkh/fQFbmlLFOeqtVRiqIkCnVdDbl
	68DVgqnVHfSZ4TFHAB6fx5YfDkdMJAQbP+uvilt4w5Egss0oF17snkaGBNgU2FajD+LiIw
	Wx860gmzH+pr0RnjPHmPDIf+h5S8ru4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="y/+b9fmB";
	spf=pass (imf29.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793958142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wxjoU6eh1AnEB74q9TNTzzgoHGIbkez0gtAfCeShC9g=;
	b=XhE1e6KjCVB+A20aBjSfUFyEDiFiJoO9y/tT7+OKkX9vtPrW7YP7IXWknflvehi8Igx6aT
	XoefmRb/IHtqXSM5hwAf5LHEoDA8VoHVd4OYeSUYjSIxB9LTw7N3ExKrfobkasFBdfOZnY
	eGu2mU+hQfjAYorS5huMETA7Q9obZBQ=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a210470b49so2696155e9.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 01:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793958141; x=1794562941; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wxjoU6eh1AnEB74q9TNTzzgoHGIbkez0gtAfCeShC9g=;
        b=y/+b9fmBBvdF2fIo9CXpbB8synYmzH9jJ6AIgoMhIYzgWKRDda3XuBGx0b+/p774nP
         8nKU9KpUTFqI/mPlAowaiftOyYZZ6hK+NU3gwI9EtYOwtGsEXzpVoFA7GWfwio/49tzX
         oyuoQ/49afHxEq5e8Sieu+fE6gQU2ZZDdi8n2A+EuSx2yWnGeDbf99pf/qIUwBsedvVI
         P27d/iH9dR0Bajo1gY2nkbsZiJukf9tmAvO2TPOJCt46EEMVQ0qrXEwuZXrqtJ5PJMqP
         NBx128EOKcEeBIod0b2AEn0hLv8nCjqTq8ME2GB7OLO9Q7YKsEJ5FwxLgPNUObp3GOhb
         8WYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793958141; x=1794562941;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wxjoU6eh1AnEB74q9TNTzzgoHGIbkez0gtAfCeShC9g=;
        b=01016W1b5SokfD54LxezTmnLG+5UZigATxEVfVxicC0GBlI7v2BYPwWMZs4l3zQeyQ
         CAfYrGVqymwnNHyzTL2EVBlyuFf4tS0hfQVhQ/m5EafsvA0GmMpCSC4vRLjNI6DPQF4h
         xQEVi46/zqWZk+Lbm+24mhI8/NO/TTPXSJbPJuuLle+qSVW1OWaPyod9n6ahqW+w+kwn
         bgRDg0fVxb0UuojFNbJ6Qv5X0Pz3q7Dm0t1K01vjXGLwlRelAs52sonb6Kjtx9KrWszc
         OZNDQ2VWj3Qr4hLTH3AFT/oGTqNmKIDTe5R/jLu1kbItryB6ku/b4GjFRlxHS0OukPmJ
         iwww==
X-Gm-Message-State: APuU4Z8ZQa7KQD8Cr0TVUCjugKMT+QOdPb/odKswWs8EBmjJRPMOaDfo
	/RU7/vYbN+KN78XxN1Whva3DpuqLrPr3TSVfAcAr/QP91fDIgX/kUo+k
X-Gm-Gg: AYBFou17VFaNRtE3XAC3ncw8KlrkzM2s8c4tuaparDMJQQGq9JIEYMUhP3vXqAZOK6f
	bArvddXIKOuo5HwX8eYh0DgJEuY+8RBCE6GAou/ThfQ4Y7xxFyo8pBik8i68FFbpeOuHHladzE9
	DtOhahxyTSJ0v3XmxZlyFqPemuECdI4tKtBhTS42S4zV/v9FotOEQAGAfWYGAGLHF5mnm6PISNF
	Pl0skFZ9nRee15EJJfcmTIVgjAzjurc2y/YfuF1QnyS1RYZGWo3vOWhAttluMttj0TvUo9C8gkw
	cS9vbWtN6d7vzuQR4bzRphMSTeBsPhK0xXhVGTY9UwnMYsA7IfqKuE994Dp0DMjuOf0adAVwGAS
	0olqeXH8H4nbf1qwT87CIX0mjlYOBG8r3S3Jpax0UMWzoJ5jVED5Ad4bYgcGn0m5hRrQM3D1AbR
	bsrusJ4MOBitLBNrDjC7OZncWIX4SHLE19zvE5B0bUvgvDlCYSrzzDuY7c7YPLKPAkskVLlTZ1v
	egb5xd6KAY1ACRnoKftysQv66Ez4gWzEbq7T7WOse7ntlNWzJ3oHH/vYAMiP7APs8KCMVqVQgpQ
	b+vr18p63giiSt6J6KtDWic=
X-Received: by 2002:a05:600c:c168:b0:4a0:1c0e:b057 with SMTP id 5b1f17b1804b1-4b6db2ba2demr25269125e9.4.1793958140866;
        Fri, 06 Nov 2026 01:42:20 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b741cdd8d7sm22361285e9.1.2026.11.06.01.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 01:42:20 -0800 (PST)
Message-ID: <528e3a0e-04fb-427f-88c7-63a7f4bbc505@gmail.com>
Date: Fri, 6 Nov 2026 10:42:17 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] mm: limit pagecache folio refcount when mapping pages
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 iommu@lists.linux.dev, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-1-70b9c655da3e@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261105-refcount_overflow_stable-v1-1-70b9c655da3e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ADF84120007
X-Stat-Signature: zs7dxwpbjmbfoq8hykpsrq4pour441ep
X-Rspam-User: 
X-HE-Tag: 1793958142-671148
X-HE-Meta: U2FsdGVkX1/ThG2QQVLdzgQMYMYpOBsBKTfNMr/JOoKxZzzuuM5AhY+y6pLjtHNpGRYsBxlAIt3m4w91c8bJea81MXtSwpzwAHDuJ97BnYbigRmEMPaB/y3EQKIbF5bG+EzTHu1QeSVkUbz0q//Ds+q9h7rAF2ZX1gYA62o8InxIqc4OVdLboJqSrG9rD6x4/uFUe+B6mrXZ+aKKQk+4sGtfzZ8a0wblAhl0RHrAev4Y1kKfeLS5HZdH7oEBCWgR8zu7qrsY75uMudulHHQLtkIdsw+f34iVBZR1YjgrpgcUQgNTzdqhxp1Xh1S84C+QhvZN9YTCSXR7U7Cfm10c+Cg8Fmhd9u507vr5iwUmIm0uSp/SiqiPPilV2upeGrV4O7y2Sv/t/n73S12w1HX6q5h+ZAzA5XTjJ6wH02cu3kUWhMjeGIXM1FPZDCe8kT+eFyAAQrH3YfGj3SAQ6xfkYKd/J5iJoFsAlW4xZcIRRsj4NCmVBdxYtbQ+04U6Rzv7rL6IoQbG+qfN4Ie1OI/LXn525BTwxpcgp1qTX+4ahbu1Qzvo0ICNhgSjfcRHoZWhRzU8qitgX5a0lCVv9RW/sFGV0tFbKrdUHVjpPG+z4ReAXOtx6unKP+6Z1oNvRHg3xvFXuFHgt2vu4rCELPnFP5JZAy2jIxT63Usr9J09h2wbVGBpsuS/DdgOD+WEmw9jml0qEvEiY7n95RDphly4yLenhMUVo7+o5cACoG0SzTH0jcv+XTaahc/k0lghkdAFptp+LjbHuaYQ2La6Mb7wVm57nhnpdKoiDVxI7Vous8b9miqUG77tBvBMTMjLoZVxcaYbo9mZ0/Oisk+ZAvKvmYaDvD6gP13CESlrzLjUzaHyT6NIm0YacDadAoK9ILTK3X+lQYLysD99z6LWJbvQuORrXhshMIZcVi35XrEGE6lduFC7oUQ2eq6bAUmFGLP5a2emyJU+q7SsHzKaxuq
 S0w4UWBm
 Y41mbmSjCZiCHM6JJyE/I0vU3rjcF0g5vEsHxnMRC+urMPbkycFg3wprrpaakS7h0vNnpcq/eVWW6VmUVCBI9xEMzSPksGKwV/Pc8PpZ4XKdP+5BCrUF/lu2pOiiOQIlCp2P+xMiqSmP17Ux8vdF7gu7mKxpxvpzD5zzPrdWiOU4vFKk9NfDl3E/QxGyOVYRJhulOiv5hyCpYK57463W0ok8S/Ctlv/cOpz7V3nOMnrxwq0K9ey4QoEY1AwuigshsZE3SFoqJNmCUbrC/eADvTZwhqSny+1J3gUgmYsHa8cGBm8NN93wrvUhlIMd9SDFOwiNM/7apJwSdwD1RV3FdfVdO21uqlnzVim1nwHW9nT2p26ZvKuRmrBsPW37681aJC9v54WW1BeLFdIipF390D131sGCSq88YxGDBpFc/M5a72W4gLcqSSDo/AfmqRp6qL/zjgac59uelSo+O79hNB/DKFuc+gT+oi3iG9YiGpyMb4k0PUstpTNrds98hOtIvXgeT5ztMPmZXJurTyp4NyTrBxHcyIoos7jEl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 2:10 PM, David Hildenbrand (Arm) wrote:
> With large file folios, overflowing the folio mapcount and refcount
> became possible. For anon folios it is currently not really an issue:
> each large anon folio can only be mapped once into a process.
> 
> That's not really big news, but it's about time that we do something
> about it because some modern technology might find ways to abuse it :)
> 
> One of the enablers for that was commit ddc58f27f9ee ("mm: drop tail page
> refcounting"), however, file thp support was added later.
> 
> File folios can be mapped multiple times into the same process, allowing
> for processes to hold many references to the same folio.
> 
> As a short-term solution, let's introduce two folio refcount limits:
> one for ordinary consumers and one for admins. Leave some headroom
> before the refcount goes negative, which we really don't want (having
> the mapcount go negative is also not expected).
> 
> Start reporting SIGBUS if we run into limits. When restoring mappings
> from migration entries, instead zap the pte/pmd entry. We allow for
> slightly exceeding the limit to keep things simpler.
> 
> This is far from ideal, but better than all easy alternatives we can
> backport comfortably. For now it fixes the big problem: letting
> the refcount (+mapcount) go negative and cause trouble.
> 
> This is only a temporary fix, we'll follow up with something better.
> 
> While the refcount checks are not required for order 0 folios, let's
> just add them for consistency: each folio_add_file_rmap*() and
> folio_dup_file_rmap*() needs a prior check.
in mm-new copy_huge_pmd() now does a folio_dup_file_rmap_pmd() at fork,
since Konstantin's "mm/huge_memory: copy file THPs at fork like
copy_present_ptes() does". doesn't that one need the check too?

the rest LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

