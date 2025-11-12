Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FBD4CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 07:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87A1E8E0015; Wed, 12 Nov 2025 02:52:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830728E0002; Wed, 12 Nov 2025 02:52:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719F58E0015; Wed, 12 Nov 2025 02:52:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8588E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:52:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1247E4C6EB
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:52:14 +0000 (UTC)
X-FDA: 84101186988.09.F2A2C19
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1731C180009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:52:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UC6uf+YI;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762933932; a=rsa-sha256;
	cv=none;
	b=hPzoeZdEMWv6XniSb+4rm6MHlw/YNoEvi/dGfy7h28L5k9buqM02HS7f5Uc2imSfyqsac9
	9Cj3VzwtqlCJLOvJDfmyDFHGvVgHGAsocliWoN9oH7vEsTUXfmNGIK+pxCPv5Jv9Ae6Y0I
	mkGRL2bNhdEdtUr54M8EhiAdcttG2iM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UC6uf+YI;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762933932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=baF77Nd6PddrT+NcaQcnWaJHYcsWM5/03L4b2UgZmEs=;
	b=SgDoUwWFmKhcmeedduJQbKGJEMUQWo3IGbdISsoEX5DsJVuQMee5VAXN0309FpTsJ6BIXi
	EElBuxdkxqO5Jqss5fJER8tgtdrkpZrQn9BnR+V9BP9t2FQAIow5b3FLLAnO3zXFcIfPJN
	JPPZCX0ZgPBReY68XJKi8/+W10EVsRI=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6418b55f86dso650642a12.1
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762933930; x=1763538730; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=baF77Nd6PddrT+NcaQcnWaJHYcsWM5/03L4b2UgZmEs=;
        b=UC6uf+YIxBBnhQjGlSW5Ern1bFobLsAr9sAglMpoH7kdWYUEqFFyO4IZ4AHwRGKkoo
         kFNTj1TXM/OphOuU31zrhonQw1YmPMarQcfh1srvYluSwMsS0Byqtth4MCf6h8DTJWIT
         u3p1p3bPtt00Yoa0mlKMzF+naif3DUJXa5MAPox/Eep1cfJY6JfCEM5PmrlTKOx8erKG
         5ROevRUt6PTNCz7X4xav9TypEnkKiXxf5ojQdhVwZdJYZGClrztdjnd+HYiYvKFtHx50
         4yVEiem5+Iea1CwJIsh9ei2Nqbf3eSjow002Zii5ix8s/JBLYxRvV0qTk1DJYHEKyR32
         4AGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762933930; x=1763538730;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=baF77Nd6PddrT+NcaQcnWaJHYcsWM5/03L4b2UgZmEs=;
        b=fGki6EDUHR3zack32I+qUIa7bT7kFPGmpwN29/iDnDSx7xZrRnyO+cw0Wivk4Rdg+7
         kwnZQXQEdmKthTwzS32wLlnWzVQVq0Pa0QaQmN/Slt/jiSmltqcxVAHiegDsB8lGjDOb
         rDuqz8nRzHL02xlLTgQ9i81CsONL0RMVW6/2gtJTSVCDBtBHHPVuC6JUkPT6wuZgO3k5
         XYdZH8/mL2j7GNiWkpPcgIRRxwdjQ4HeWb2inQHrSJ8r2oVLenFtJS0kEm3po0GOSPG0
         2vXjQcIevUs72+6ua16PwzpE3JhlMMA8CT9uxTXS0t7EbXUYqdA5jWTEcIX1X3uH3udv
         4ZKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpFtao7pTcrifGGURfJQ7Ot5Z9OmlHGzjucnt5cqnX58Rw/Yn+BNza9DTnvAOKHI2OXgU2Mgy0gQ==@kvack.org
X-Gm-Message-State: AOJu0YyBad5aWmLmpJ2TixW4kDO2UNC5CJ+IJPWXitC1Mg7c9mBQ7UDb
	Zlsf7amfZNHzmrboAZyPu2VRFzkZwLdI2GYEhjYAI6N4EN6Va7XcR0vog9EKevtUXUk=
X-Gm-Gg: ASbGncv01a1TSkm/pvqswpQYmtgJ8uZx8B4w/9WUy9Beg6eROFguZ3I1M8DgKe9CMV8
	DDNQXVRPbF05SGFchSGMNrs/xr+D6gTC5yZ+fkKcoMqwdzbcApYP2jAqYvuyMWLgO04zn5f6nB5
	eOGdHA20Nv5NpQy+L2idoApWe4diVCBleCuaWtDep2AKkGWAJJybKNpGCPTZB4sH0oE+MGZFYn7
	Ciq8NwJrB4dlJx0Rxk7054pCuOgCyP0i1koBJdQ1F5Pq02UEEWTDUvR+lF2zdk3bAnFlL2OH/Kc
	VHheYnHSJO9knwCTrDwfhg9F//9dORZdR9Gp9isc6a4+67hzTNbxxUJ0gNpIPB/itRUHfBAP63o
	j/dxhcLr9mCkPctU5C5pYURuQ6vWFZUWCHj/7Ka03l7ble2pIzfJ3ZFluB3OabD/fbkqWaHa0Fn
	+m9WtsnsmBIBMDdg==
X-Google-Smtp-Source: AGHT+IHrUFgBXB0mlhlDx5ulVZ/CWC4rg/lpc+ghJAkmKWSBb8GGXulAMnQrIW2KVp+058faH6NYGw==
X-Received: by 2002:a05:6402:218c:20b0:640:93b2:fd07 with SMTP id 4fb4d7f45d1cf-6431a579409mr1286553a12.33.1762933930379;
        Tue, 11 Nov 2025 23:52:10 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6415d91f486sm10653900a12.22.2025.11.11.23.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 23:52:10 -0800 (PST)
Date: Wed, 12 Nov 2025 08:52:06 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 14/23] mm: allow specifying custom oom constraint for
 BPF triggers
Message-ID: <aRQ8pu_57IeA_Jn_@tiehlicka>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
 <20251027232206.473085-4-roman.gushchin@linux.dev>
 <aRGw6sSyoJiyXb8i@tiehlicka>
 <871pm4peeb.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871pm4peeb.fsf@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1731C180009
X-Stat-Signature: z655dhy63kwbz8zcxb9jfbpig57goagk
X-HE-Tag: 1762933931-599237
X-HE-Meta: U2FsdGVkX18KwrCR6qSpdfDqkmEHBiGCHgrY7SASsWNshDl2UBuO76dwA5dNS4GVMaODdmGcUwC0bCWkFogPJfXADOeZ+rp3VERcSyT0GsYCbMDv8Kmg5dmc6mvAgu626mg7h59qq241hU+wfVB8oOhQl1OitoWRDS5rg8/TqO9FJJ60tSxlia74kPCKM87wZ8TrTTortqr2R6dGu+LcmfvSDmulEKWmRmuz3I/pIvqvaB5RaQAa1cDrGUpKWgCdH0NCjxjsm2e2MNePpHZd+n1xcgweNhVqISQZkEY1F6LPxeOIdHQ34XONbM5wLlr/WNMys34KjGUBfjKFs5y3VDvEasjYXxM/gvY8xWxrbmslrgobrsp0HdHe00GzZ/6h8lhHf2kevWCZBQCfRkgIUXWxRapn1f63fUvrn8Ta21RdWOqsxxqbI5v3bepoL282M25bVTj//e23gmUrNjER/eIgtmbZoav7DnXGsrI2npTu4fAAOO084t7zPFPW6gYaLMMGkOl+v2XmfXbo+9rWi/CNx7tTpQezLHlP8fZxCaYFQt+plBDA9tJ1Yjq4a25r9hnZvEqrhNL3rE+HJj87+2KdPkKBdV2yrGhxHZCZZ0vBuZB7f0ey5JxHIFRBoUHlEUMtXjv8xyWsCTStfYSnovB7HVZV/+KoUHgdnshyT6Dl2LRJglFOC7AAZmJyzUvSb2GZJy6fh+yDXIo/Ac3o8HTEP76fgQ+eU7NJuZ5nvZJezNQXOaw7eu5kB+QfVNYQMT4UZgLy1TRwVuatCh8IELG/7qJBFFtKq1/9tNH6zcvC8XPJSs3u9Uljvs5j706EX2/L9dsHTihn1+Yvs11bmzTOm711jGHWGJqHjcmGmo3J0LTnJmE/cJZRTjGM7kOSWNBXBOJxaNAnSr9igEwDTTRUpKZMhxbfm1fDGHMw7Par9MYM5VJqPLu2sCDCjdCLdIZ6F5ZfgrJ8K+JflK7
 Atq89uZN
 VSOnVwclj1WdTzVmsFBayIG1KZM615pBmYYLY8sYihcn37o5MUyaJSUgfW45BpZQ9cCnAzuvkYFllkVeHxojNhdM5IRth6ezbMRb/FXsvMuVhtDz/sCWcWHoseLMfDNiTdzfO80iWezleS9BKb636y4nu6/KIjSOeioKm2X5CTRWmI8G2N3VI3W99C/vGsPkSa+Hzh4PkiEYfj6eWWxLblSYzgWoYjWs5iq+Ofg5DpOmCbpAGgUiKS3VGCq8HuBzBa5kyyXg98Oc1Zo3ygxl2pYJh6J6H3mEA2jxBwjpV8VOZ0Q9c+JEx187zuH8MIxTT0rG58KqtV9/O9OpsKiVI+oL6oOy5/ahS7Mmm+OHfkx+RFYczb3MQIfYsaijoG/OLGKtiru6L916pME12tfORTKoeDJ2lYgXKr334
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-11-25 11:17:48, Roman Gushchin wrote:
> Michal Hocko <mhocko@suse.com> writes:
> 
> > On Mon 27-10-25 16:21:57, Roman Gushchin wrote:
> >> Currently there is a hard-coded list of possible oom constraints:
> >> NONE, CPUSET, MEMORY_POLICY & MEMCG. Add a new one: CONSTRAINT_BPF.
> >> Also, add an ability to specify a custom constraint name
> >> when calling bpf_out_of_memory(). If an empty string is passed
> >> as an argument, CONSTRAINT_BPF is displayed.
> >
> > Constrain is meant to define the scope of the oom handler but to me it
> > seems like you want to specify the oom handler and (ab)using scope for
> > that. In other words it still makes sense to distinguesh memcg, global,
> > mempolicy wide OOMs with global vs. bpf handler, right?
> 
> I use the word "constraint" as the "reason" why an OOM was declared (in
> other words which constraint was violated). And memcg vs global define
> the scope. Right now the only way to trigger a memcg oom is to exceed
> the memory.max limit. But with bpf oom there will others, e.g. exceed a
> certain PSI threshold. So you can have different constraints violated
> within the same scope.

Please use a different placeholder for that. Current constrains have a
well defined semantic. They are not claiming why the OOM happened but
what is the scope of the oom action (domain if you will). The specific
handler has a sufficient knowledge to explain why the OOM killing is
happening and on which domain/scope/constrain.

-- 
Michal Hocko
SUSE Labs

