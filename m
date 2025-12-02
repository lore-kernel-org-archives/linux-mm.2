Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7903CFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 15:36:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4E66B0022; Tue,  2 Dec 2025 10:36:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC756B0024; Tue,  2 Dec 2025 10:36:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29BC36B0026; Tue,  2 Dec 2025 10:36:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15A0B6B0022
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:36:23 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27E60139A0E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 15:36:19 +0000 (UTC)
X-FDA: 84174932478.17.C6975E0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 90DCE40005
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 15:36:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XyNmdxnh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764689776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YeUhnIQnNrHzJpcHAzDpdS8MH/0dybZ954xw+b5apLM=;
	b=EuGSIZgyRLe5xk5/EsS9YbjXT0DE8YVH/Lt3ci+OU7OEUA7buP1K+DeFFDm4QivMhk/NSZ
	lRcwTH7Q/iEtWOF61jZItMIrfuBJmeQp5w5PYrEpHUI+gnof8fxmVv3wbE4a0m9+lqELEj
	CPk6bwzmTp9+Ub7oXkkehw4f4IuXCOQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XyNmdxnh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764689776; a=rsa-sha256;
	cv=none;
	b=BhzVXOc7N/XtxRmTZ0DYcOsgVWqhqzLxYtkX4nyLAZepCNaX8q5boW/Bi99T0xKzP4+9cU
	0Pg7Gca8mP0Oxsd6/fyFr9CjEISYSCxBg1zhG+Lc9krF6UvQHwf1i1ooxfw+B6/m54wv5i
	iSNVpZy4Hm9jKiBb2FLKKOd52PcJzJs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764689775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YeUhnIQnNrHzJpcHAzDpdS8MH/0dybZ954xw+b5apLM=;
	b=XyNmdxnha6ReCpgBQljGY7HRN4IS2CQ1G7uRnJNX0FOGZ8ZIeijj3Te55PnN5E9HxPTFVo
	pgvjBbrZ7n95cmd18qXW2Sv9FKHAffBBRlm42TOcsiOnSMNF4LrnP6Ql8MOS20hVcvCowd
	N+f77epE/x8UtHrGXcFzmamT8KpRox8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-8K-IQx95NheoKwM27RPd3Q-1; Tue, 02 Dec 2025 10:36:12 -0500
X-MC-Unique: 8K-IQx95NheoKwM27RPd3Q-1
X-Mimecast-MFC-AGG-ID: 8K-IQx95NheoKwM27RPd3Q_1764689772
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4efef582d65so63062391cf.3
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 07:36:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764689772; x=1765294572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YeUhnIQnNrHzJpcHAzDpdS8MH/0dybZ954xw+b5apLM=;
        b=s3nddujb8gbTtxDi/Ywbq1BqMapoHx9EglJ/zr1qshFU9FkG3VL6rtb1IpwCynkwQP
         li4mvpUwnWlFR66PAlohG9Y4wf5wwuZUu2V/slRZC68jksU5GHpBemgMYuy8Js0oQgK7
         2tdAsSkvzprWRlWF7luhVUmFW3Nslogq0DLymj2tei8C6dtk4r2/LQ2qNxBAM6jz/DWv
         LhKTA3qeJGDzYKThiVVo9baFCeQ8xVTIV7S/3hqF1uMT1IOVs92+yU84+DEFNr9h340M
         zTrwdhxkKOY3MlRIxPMp4RiYqRHS5wx5Ffxi6SPhIHMSVEHMgvV1zT3vI6PaVIV17ZBi
         kvjg==
X-Forwarded-Encrypted: i=1; AJvYcCVa897FnWSUEWmRruJYoSKmK+eDkLNUYP9Qps1YJWLfVTuVhF2DFyVWbgb3fdylTkV46CyzVjf1WA==@kvack.org
X-Gm-Message-State: AOJu0YxjPK8UOoGSdVlU2PWiZGpoeOO2aVTPrvxBxwEjX+7P0DlSQPYG
	BGdwYm6kmhoPvLJrhVX+SBVnxSPAL+R58p0KrK+dfcNuavW/bfdzyh93Km/k/pHl2g5HYDWqkey
	eGZdFDj6NaIEO3VpIOQevAuldacBNvvnQd0ea/S5wSx/SNIe/9Jmx
X-Gm-Gg: ASbGncuRoMjXqwN71/ryVj6FlRNCPAK7Yaoz4PjHoW+oZSjR6chZsEGJUZJ9ByTqAgO
	sAkgciJV9uoUstQ7rBirTMvMxmjK+cfwc0EX6WkECH6j7oJp62Zw6RjOM0d/qAVCo5NN3QHY+1X
	IRylQiYUKsuung6S2uXVnHdUJ5RO8LDvGDs0HBrRfklUdUAdiXLxwvFqOCN6Oc76Vo8VM/ux0oK
	mcid6bqvvyvqyM9HI2iv/JTxPwoKvVv0pC3ERflU1V40oJmZHfZ9bJ6oqNoXhuWCnHRJuJO2DE8
	RgY6rBTxt3Y+2UUhEsVgLUpet0zQmYUbK9SGEUX3T67wW7lxGaC1VctYM/bBAY+6Jz/435717zf
	JYcg=
X-Received: by 2002:ac8:5a49:0:b0:4ee:41b2:91a6 with SMTP id d75a77b69052e-4ee58b066b0mr583360561cf.82.1764689771721;
        Tue, 02 Dec 2025 07:36:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGLXfWGfXaBCM5txXHiaHxg/MnHqIkbYXvhInhcx15cakUIHeqTAWdqvhhC3SSFQ3wIt4nqmQ==
X-Received: by 2002:ac8:5a49:0:b0:4ee:41b2:91a6 with SMTP id d75a77b69052e-4ee58b066b0mr583359971cf.82.1764689771231;
        Tue, 02 Dec 2025 07:36:11 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd2edcebcsm95292531cf.0.2025.12.02.07.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 07:36:10 -0800 (PST)
Date: Tue, 2 Dec 2025 10:36:08 -0500
From: Peter Xu <peterx@redhat.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor
 mode
Message-ID: <aS8HaDX5Pg9h_nkl@x1.local>
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
 <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
 <2d98c597-0789-4251-843d-bfe36de25bd2@kernel.org>
 <553c64e8-d224-4764-9057-84289257cac9@amazon.com>
 <aS3f_PlxWLb-6NmR@x1.local>
 <76e3d5bf-df73-4293-84f6-0d6ddabd0fd7@amazon.com>
 <aS4BVC42JiUT51rS@x1.local>
 <415a5956-1dec-4f10-be36-85f6d4d8f4b4@amazon.com>
MIME-Version: 1.0
In-Reply-To: <415a5956-1dec-4f10-be36-85f6d4d8f4b4@amazon.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: U1TTdyj9sNVgYytlqKWflD4GeDCSz2aPz75mIlSgy_k_1764689772
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 90DCE40005
X-Rspamd-Server: rspam11
X-Stat-Signature: xezghnhbyi8wuq9dc1asw8s7uymanfk1
X-HE-Tag: 1764689776-756815
X-HE-Meta: U2FsdGVkX1+SgfV7VCfBzbnw3dGhZnhJ2o9sDUdiNsazPG+tuu8+X9ndvUKCUdU5w0l2KTiyoKWHNNTdtDHhoLlpDmFVGT/1E5gY2x2sGp/+FiRbNLBRMS172qWFHmwhUPHGVZiIoztQo7y5UIdFWGj8WTD41Q1xdsmn+XEsUKjwQ0RPsDr83yU8W2n4BkXnzb1Ps6ZnxClfRz4t9SE+OYYdEpomalaY708teMgM7eLa0/LmFoEMH8ZkhWu7S1CTlH1gS8mC05nAD/g7/jmq1kdRt/9NJaDLDuAKBHU1TqkaXDn//+vxelG5iMTUnf2+jstv2fNExykMBHDGltADrgWTdPn9AhHABxjEs/5U5tqY9MwvgKeV6uNiEAem9qqb//KwhEDNFWnY6hiJPDBCaJFsSEfXMQZ2URm7F11FxJWndAE7sEMhEtxAXJ/GsIFz/h1J1bifaFBUzwbbqOt0TZO5g2o8guJ6WF2mzHeXG/pyVDsoSTtQY8Mu07xLNkf2YFvK5WtXrEnswjrAi7t4+yKFm70ZGnHZeEfiDv762vPa6AbbDqGrPmPGQo8dccglawBhhbx0H19eJWBPdvSL5/+Jg8NVwpzF19zXq620RgPxg03UbJOIp6YYVsa7UsDLY9t2R+Hy1gIm4NqfNWE87eGWjpC5aZuzFNoZ81b4UWsuYg/Ra9SOeI7oKVwdALDWycngBS3ltNIRqE7WpXgc1NylNeBZlEhieR4Pk83cLGFehBp7vdSB+wEduY3g/g6xbR3VZ+4e5HpPaWvmRheckMsdDkDEPbm1TuYVIxpl/yQWjCsRrkugQLrETNq2Av2vYUqH5sMS9cvZcEraMBcKZV6VboyUFSXp5lQtnwDWaQtTtgBJ/QuBxr0V2WBQN54b2wwd9uRh6/FYkCij+RRJroBztdTp7plU8KCcytziIdOk/00Skqakwj8y1amkekm53Pxs6yEUBqx2ctbtmkN
 61DSjz5w
 ZzRmWAf3yMd3B0LJaQLGWBVyHk6A+QjUDr+zXUhAyvE4Ra4Xf5Ex1PAVmCjD53g+0zF1J152rJ3ACN7S107Pbfd54j4VhRzapy/jfyh2otvE4FCee9ayw81rzGGdDCy5Za/H+pvpQA9ibzAw2kawwtG9ehUxbYBeHMS0rMu2O4+BQE4S3Ghxk4zL3To4jftz68bGTckURU1DaPkz9nkn0sPXNEQoI07k9SAftPh8YFLwr+ERUtwlMMJmxI6VU3xgkaH8QsNpVsKoZdT3mm9YEU+VZ09JEPRZMtJecwYgOx7vzXFynQe2ia/q/hudI4t+zRxxNkWK5fSZWtIhQSQ9IFVpC4IY/rIXoOIKLXW/i7EaRha0MaSJXQuhjyeI0BFohSCs/6DSCwLGuyF91JxDHeNVwBjr5PvoEOvRMG7IMW77NQxsiPwqqs2AppmbntWSYym+4iVvElH/RY8w8EodyAfr5sbC6IL3keWGfXsYOxfQFM9+rDiXqnzoGKl5MGUQ74YDvLupKKWPNgoloxEU8mmLpfuU7Rr302oEm21qrq0wXRi0c7DgwwMXrqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 02, 2025 at 11:50:31AM +0000, Nikita Kalyazin wrote:
> > It looks fine indeed, but it looks slightly weird then, as you'll have two
> > ways to populate the page cache.  Logically here atomicity is indeed not
> > needed when you trap both MISSING + MINOR.
> 
> I reran the test based on the UFFDIO_COPY prototype I had using your series
> [2], and UFFDIO_COPY is slower than write() to populate 512 MiB: 237 vs 202
> ms (+17%).  Even though UFFDIO_COPY alone is functionally sufficient, I
> would prefer to have an option to use write() where possible and only
> falling back to UFFDIO_COPY for userspace faults to have better performance.

Yes, write() should be fine.

Especially to gmem, I guess write() support is needed when VMAs cannot be
mapped at all in strict CoCo context, so it needs to be available one way
or another.

IIUC it's because UFFDIO_COPY (or memcpy(), I recall you used to test that
instead) will involve pgtable operations.  So I wonder if the VMA mapping
the gmem will still be accessed at some point later (either private->share
convertable ones for device DMAs for CoCo, or fully shared non-CoCo use
case), then the pgtable overhead will happen later for a write()-styled
fault resolution.

From that POV, above number makes sense.

Thanks for the extra testing results.

> 
> [2]
> https://lore.kernel.org/all/7666ee96-6f09-4dc1-8cb2-002a2d2a29cf@amazon.com

-- 
Peter Xu


