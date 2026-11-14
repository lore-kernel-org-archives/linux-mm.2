Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01086606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=rjay+nzw
Received: by kanga.kvack.org (Postfix)
	id 8997C6B05C6; Sat, 14 Nov 2026 14:57:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86D806B05C7; Sat, 14 Nov 2026 14:57:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739206B05C8; Sat, 14 Nov 2026 14:57:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44FEE6B05C6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:57:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE074A7FC9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:57:21 +0000 (UTC)
X-FDA: 85434783882.12.3C7B295
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id E61C140006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:57:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=rjay+nzw;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf07.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.53 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686240;
	b=h5g7Rt+nynb5Um2k+TzjYKRedzJAsAt4rFw8AeOcMugW0PlCrGJZJyu/d+3DA4c7WVLkTI
	WJLdU/u/sRm28MGrBW+yV6ubjOrzcUmRLibnen3vekGmIfXwxvT5IOWK9pwq/cTeHnyi4v
	RKtdfAUP/MeApbJnf2TXIM3WZpMZJZ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
	b=aXnBnkDDywEu1BT8qOB02Vf7yeLNlG/gquw8H94p2t/y7tQLqjrlf65nZuPsbJ2XeGThKr
	XpSboE1LUvPO0dE+717gzuJmh0vbIsh+9TNyCqyHt3jHmPgp80SWrvFfdrDem1ap3ZBe/F
	O/AL2UPl4D7rgFvULjFiwgZWDhoyiWY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=rjay+nzw;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf07.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.53 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3b179528d56so999896a91.3
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686239; x=1795291039; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
        b=rjay+nzwnxV6wkmOIR8Pojf6sv3FSVmUUsUAyiGhWWB5tm9cEAztZUSyTFNlcOYZG4
         xJacO8LojP5sF2uNgPvbWgO8DGCGRyeITmUzTky0McQlzeXFAiyBJZDL+Y/Sm9SGaULs
         69s38M5yEpH19dYjKF1HG/QqVboczVtxZhCLg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686239; x=1795291039;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
        b=Y66x3zLcTcIa6VSzEd3i8s+McyiLlz3SH+FqeyDU32VN0UIma5/1OX3sIcvejmNSvH
         fl9rtmLwyN26yfv4Rvm+KiTHy0Jb4XUG949AXFjnyAMbXhIHNaDj+nJryWFVoZ4IbZC2
         g6KLDT129RZj22pnxp3bd/vtV3R1Zt7Fa9N071WY0yDKN9jIw0RGhv3xyqfBysx7/Wr7
         boJ8IGSNCzIdl9CGJtajIP/oUUqwikC5XjOPdZNBTWQgLFueSlnl6wceGw/CUnpjOsfV
         MgOqjJq+IhIv5JmsG1FyBcNZsxq+krPPSZ+yfHGDjdqLsi0z1mQF6fi7UKB9usEEZyKy
         06Zg==
X-Forwarded-Encrypted: i=1; AL+hErE2MB3rpL3XCFAMB3ae1x3dv3b0z/kzq0PIzQxjlJdA55JaXkAASMh0cYVuS3JLJTmoKFm5TISMaw==@kvack.org
X-Gm-Message-State: APuU4Z/bNcnwDq5BvghalXbBgPKd8FLkLOC8BYzFZByvTKXi2TycmOr2
	MGtwII64oQli1bTF7UXf3rpsJiSbtCLFCe0SfFg0Yb51aTR9Xc4akAOCYBki4dvFOt8=
X-Gm-Gg: AYBFou0UrqMGPc1RxQOVjtGFk79V1C3dljbDC2+1xpFbYA8vzH6wryk7naitfyCiKfH
	6tDQuv7H4C+iZ78xQe/CHOfwkqQjZ70Nb+MfgXX5iO1YjgZgAJcFxKmNmF647piw0Yo3AQ6TPlA
	7+iVwPmqPjRBCsLpW/ldCTK7wXBqzsP+6Ne/GVPjpmiDFgM0yvvM09RYwgaeOwgLM9Wso193GST
	14v8B5MsM6CJOH5Gi37097L5Q2QpAPCMavacv7vGVx/PqP/RQBVekAjFsV26iMTmBaHr+P4SVtM
	bH2jGYx/hbBqtwTFoTWn1kBLMNS/IGV1DzK6GwU6EmVO+W0pXx86sWKRXGQ+LPsZ4QxMZQOxDx5
	tiS1x40WKSw1qxFxWdNym2ZVsHvA7vkjq2+Q3UPOVFbqykV7aCUWIv3UROUl/6NGnhGMDY9gj6H
	VojIFqxe8pxOoAlCqPyriVQmy5rV98ezpmXwVSjRzDXZrkQZ72mJ1RnuPA3KUYzJbmZBpE33cze
	QqDY2wNLjolPSQ3OwlqFQZ2MBwlVHuIDEbkwabQd/uAjV4BUIKYs4Bacbg1yao9PfhvuqWdpthr
	ztAI/6kPOQ9ulDbY7m0JDt/xSc4lgR5fTWGnq8B+2eh+/5L0v97HntBo1uOhwySGW86p8fIQreQ
	7UzRgEjuKYz9tHt9zJ/QQl2/RFYMUxwhayJe/Cj+lVUs33yqJsDkZQIPpWY2WwlOnAQXdeqFqAO
	RaHbUcXcu6RYTy07YNLqTl/w7+tQJ/Eb5kxrI5olCmrnFXStJt2RHI+A==
X-Received: by 2002:a17:90b:2e47:b0:3b0:9317:5849 with SMTP id 98e67ed59e1d1-3b1b07e9b25mr4925477a91.1.1794686238731;
        Sat, 14 Nov 2026 11:57:18 -0800 (PST)
Received: from [172.22.0.2] ([4.16.0.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aec3a903sm10737441a91.8.2026.11.14.11.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:57:17 -0800 (PST)
Date: Sat, 14 Nov 2026 11:57:14 -0800
From: Chris Down <chris@chrisdown.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
	=?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 13/13] percpu: queue the balance work on an unbound
	workqueue
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-13-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
	<20261113-mason-migrate-et-al-fixes-v2-13-50a2ed382b61@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114115714.04d384f992f7a635@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Queue-Id: E61C140006
X-Rspamd-Server: rspam12
X-Stat-Signature: 6arxn5s36n36ut1tagpjs88mcru1mj7p
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794686239-569851
X-HE-Meta: U2FsdGVkX18qFjTzHQWw/8v+wt6T6ZiaLj342RsTvS4BOM7XmCBwmX2eoEN+foyBvtTnRarkup4Wk3M6p/P1/dyX0BJM9OuOGMde14DMquFdmLlalRBURUofj7kPYC/S0g55e3W13jgGSIo4sKb3KLORUAHWpR6uoSp2pmBrjCjWgGqqlh0fkbqvuzNQkVFNtzrunY6vg+oE1y9V9shDEkXAuuxo3lBzIKhTvsyU5PeHFPoSQedBKsPEIJKxIy1NkeTjSBbPPT9kJSoF7ZqMrPGcT871x7a7scVr+HgXiX67vzfzVZ5ag5HGI6+9e/w8NdfiqNC9VZHIigDkaJLP6EZ9mfmOFWbR0I9V+8yZ1hP5LHXlJO8F990xi+xKkg4MOJ9SgOlP0A5Bdd8YDnvScHJqGiJlSX43DKVF7qDHlv1RXZANJl+8oPFtxxgkOup0KB/D8rsj4hMNkLg65OlTu55bHclc1y6ngmtbPd4TGfhglTX5Y25/gDR4siAItIQO6/zv+zNOqvuPoGa8cysMWsi5YUWg19I+UQCT10tdLJAobpqJIkYOhk2IVoILXlWdigUevpX/65wiqbcEO/0IVyKd5phYH7I9LDXN0XM6oZ+68lwpjzddho+wZRrAOSoFfG1sEtzO8rxZfiydoNgvsppUKUBgZ6w0TsYVn+X6OaghMMA03EKNttW47ZnLggDsk1HN0RxJUWJiKQ5vPdXRDbQWIS6fiZFap5WaIN2E19LFfOoUI7HJ/5ccUD3M4f9G9+ru0eRlhQVFJStWecfzAJXjzOpgbcIX7UQwXMps11EM6CYZUdl+VPeEx2T868d6MSpr2lnf/JkzbFkZYgwzyKgqtgejfn09QThOx4XZa3fxF9WQT/yOzaUxCzB2YRdNxqNaWre2myrhjFb6pGRrt7k7psSGqG5kt0K6NSM6+UhPY0oHZkn1XV5vtaDFq+XpLt7983FK0zYff9/LgpU
 HIMyn2rd
 adu8SIO7M4G1ykL3x8Dc9NUMEow1ocGMD/1Kvjn0ZtOUuQP1Ey8od3FEh65pfap7CtFA7mLqKTP7ie3K36QC3fkHu43XuCZijKUhSBKXeI50Q/Co6+Fum4begq89jnqoBPBTykihLmIRmBUbzC7V6pdjyrUANSA6Q98OqE9UGX8Mrvbn8W5Qgrh7WawVLeA1lCBgAw5pSzUML5GYxuvHeqBrxTt+1fmgi59jcSqan2okmybwKTOv1h8oAoEqK/rQ+SsOnMtFImE4GqnF4Dh+JThc7R1xvhlKju21m9+Qqf7QQ1moPM0HSp2W5Fa31jzlqMsu7cIxtTIyJVU30yaISOq1iNI9WT0gSV4tA2KBc7MPFT/tWBSynrsc7j9sY5DjzxF/qrhL29+CVPH5cspNASWprIA0Q4pkoMxKXhIlZg2suJrKwlhJtxtbCmQoUthvoQqeOr6lnautIUMedek/SCkLlPriEi+dfPpJIc1Kk9wEk9yBFAO7FBfDsNmKgcUjsrCl3ofap3ytDiW8rvA/ny6yhqFuFJKdANcTj52KxbULd1p2sqR2iEZcaXVaK5o3BM3f6y7D4N60lVMTNmwP6P4q4mqsy/1SxekoPp3oohSdZ52Qzd1nHQcKuxJpvMg6CRnq3iGBmu30aGhUbuN51l1GaTuAenbwjk5iMzUUX/MXZFBzfNMxdSo9I3FHTicGm3P7PXr+cM4IXkv0510w8p5c/hw0VgoXUrqkV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Chris Down <chris@chrisdown.name>

