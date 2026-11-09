Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CC8F606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 19:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XQA2qnnM
Received: by kanga.kvack.org (Postfix)
	id 024B56B05B9; Mon,  9 Nov 2026 14:48:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18176B05BB; Mon,  9 Nov 2026 14:48:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E446B05BC; Mon,  9 Nov 2026 14:48:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B85D36B05B9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:48:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 120621C3C61
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:48:46 +0000 (UTC)
X-FDA: 85416618252.16.CB66D90
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 44CD3100005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:48:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XQA2qnnM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=skunkolee@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794253724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nsd1wsdgN72wtuhrUgUrRyzu9u6yO/lsXF2Q80nLfXw=;
	b=fw+WP6NESmo4sxN0+X/tnEpjxOOJNnecRirMn2QEJtrb7Q8miOKPgwraGcZj8GQ1YhW4nb
	HXdJtUQDPJd4gkmvq+eJ58E4mNfwvdMzyfZC6SWqmCuvL9mZ2i8XhqaTW+muBB9hkX1bpU
	0M338+NJNVomNn0zxx7vaY5n4MLmJIw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794253724;
	b=et3QqseUNFPXLuzpvMfeVEfmp1wveOyw8IHTZO1KWrjakpzGPO7QLOynM5b86qxX3Ltgef
	PASNHxXw34qiOKbhO6mvnWBmoKqzxIEfZjfSJ0+4jC4ehkz5lLKKe8L/bN4/ZyDJMOZ1qR
	jzmmqLzqPuQVN5j+XsSmyvr4cIrnLMU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XQA2qnnM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=skunkolee@gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3b0b3438540so813842a91.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 11:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794253723; x=1794858523; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nsd1wsdgN72wtuhrUgUrRyzu9u6yO/lsXF2Q80nLfXw=;
        b=XQA2qnnMYUVCbvm9Yi0/PJa+5IFLpn7YOzqZxdG9mZ+G5QgToCO/5FcikfrDplsQHt
         8amhGwm0s8ia8lpQl37WS/yntFzln07G6qxTCpzUT8OcXRRoiCMQJznOSc2Cvd7dt5Be
         xKyr6ijrgsSN2huQtKOubUv8b7wAa7J0jFT6Q7c0gnPJh1A6PCeOES404SczO9p3gaoh
         PN2ED3D2kN4WAx/9QnlXT0YqJdTy26r62QlBHm9O5rCFHsuQYgVyqlxPK8zASmEBu40X
         xkMjhdC7iGvgLSgyDzwVxkdMOMamzPcCTVOq6zLXiZKjYHlv4HxNZ5XiRSh06WF3rES4
         hsZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794253723; x=1794858523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nsd1wsdgN72wtuhrUgUrRyzu9u6yO/lsXF2Q80nLfXw=;
        b=p/gutiONwSu1d343tG0pcfo0L1kFJo1Bot94yY40auZ1J8vO8YfgqX/GeeyFjkh5WM
         3qJylzSR8c/wLkXcSICa1SmWt8duNxp7YRAoDR4zRPXog1DjTTI3r4nqSzY/raRr/mGt
         fpGB/y1XqOGtWKbEqfC+V1byZNKR/5wrMip7BfFXoqoy7YOlfVl8O+CqO/Ve6XgNh8r2
         465zhYMSTATWffbmjyIivz1vIsuGQqMj4VZUZjyNSHupEnzdtrkyBlswiUb08lijVgxH
         w20f5wHXvpw+VJI0IrPoZWAS2NNYZoqlC5iw8s4+rd4/5UM1zS/TuudhJrb3lx9stPiN
         F5xg==
X-Forwarded-Encrypted: i=1; AL+hErGNNVS4DdFgNXTuuX13aqJH34Ftf3aB3yNuzswUQT1CdlTYEA7aN+0YwwCOAbINjGTUsjl5YT1CxQ==@kvack.org
X-Gm-Message-State: APuU4Z8rrnDw43zr2aWXAJh6S8sijKEJVFAKO0+JyG5eZTxxvdVed9xe
	AIIezJBz/RsZCQBAaREjEGsq8oqrlld6O7JuNeJC9Z4Wt9hwrxHNXr8X
X-Gm-Gg: AYBFou3uVThxi+9WkoP63QsEbRDqUtVTnsgpRxvDQKv+2eY2UZkEsHhufhIZvFW7ota
	BuWC1YF5S9sUxcIlTqvmyMYiwEcglUByML+Y28FTZs7MHgdJyWCb0/mqNiJA0XORgsdxkjKryzt
	q/q1e62ISu6Q8EeSM5fAbOZD3RCeYjVzBQtkY9eoNRITOKYNa6n5f5xThL+REKE55R5UTcv0+Dz
	yAzzYpPetPyYTvdPI97e1d+VQaBZ7T+Hycq8F/NxdD+t8UPDPVKPt40muojmh8+WN9AXC4P5Fct
	4OBRtUBQZ4+0NjRiSC0ioabifkxhGxllNmMccqYYCvFCHOn1eQwa45B4yJGkVgh8giRjgZQOMZr
	IsLkXxYuAAKgxRNe0gQXBQnI9Jr+SgQ39vl89lhqAGvVxy167zynGGV5zMqwftKy1UD3YlbuTCF
	W7F3sGYHX/3bH7s1UXguq3GRzxCGKnwqoU/J0AqJCHfUnrjDSv6HCUHZEpbCEDYamni5FPmDMUg
	PAWSXH7gbDuL/vsXuJGJecc2Vub4VF7ulmPQpWkrwNXiSvr5/DyPdi4JtWG8uOUgGMGtm1naYEW
	c4r8d/1p8Fx5+dBS4qzx4QfxDeyz0GNeXkgGrdIDzz5/CPXAXkZNYVZswUeSOe18WDzBVAFTepc
	0s8RczkUP3aVFT9OZc22QiDtydMKN
X-Received: by 2002:a17:90b:3e44:b0:3ab:9c73:147 with SMTP id 98e67ed59e1d1-3b166cdeaf2mr592810a91.14.1794253722936;
        Mon, 09 Nov 2026 11:48:42 -0800 (PST)
Received: from bloom.localdomain ([2604:3d09:178e:e100::5567])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b167928684sm718358a91.10.2026.11.09.11.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 11:48:42 -0800 (PST)
From: Ivy Lopez <skunkolee@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	fvdl@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/cma: simplify cma_declare_contiguous_multi()
Date: Mon,  9 Nov 2026 13:48:41 -0600
Message-ID: <20261109194841.18662-1-skunkolee@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106-cma-multi-v1-1-054eae6e2c1c@kernel.org>
References: <20261106-cma-multi-v1-1-054eae6e2c1c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wbyqhu7sgek7fe343zmedrc45owibb9z
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 44CD3100005
X-HE-Tag: 1794253724-461399
X-HE-Meta: U2FsdGVkX191eZwc0NkYV5XNlpL/dsiR6JCw/gto4twKLe2VAAYtakUQmaG9Ki3B14Y8kBvue2/QfZdXXZXlqsUPZ0vdXZPjrDp58dGapeMyFwY2XnOsNdTO5DJmCTuEh0djObHQz847sAJGUaHfN395nVn8DznRG/zJf8Fb8m0G5KwkhhSYesbN0uH3IRZVcpWlQveooQq+gt/EGrswotGze4dO4Jo1Td2tgHEVtOw0pMHmQQBBp61bA6Tf0O7jP2M4js2//wBXM8dJa6GkzH6f+VLNSUMfFeGkpCNj6yaEObw3Z+NeBH1TIqNHRqIC3qfT/J/Q2SdxQtHXN1dL5gtjLeLhV7qNvo6NmvbRf1AvLZdJOHDrds+z3CgC8Z1/BcjP3V0y2+o3qKmWUO3WpsSIQ7WsPSRutkdjBYt8Z8t5fA6iA5uWV4AjQRavjNTy4JTBO27hc2Y3WYOCuGq737BKhpCAEtlWDwhkfTK6XKknNF/ql0g/FdggIumacku8wFLoO8v5DRbOWJQCq/qfygnsFD7msccp1jy3L5iB69EegKu6vQBlmeLW5RL4qof2Wzw86Nzwpyw4aXvB4/yA4YQRqrL003rDa+x1ShmIBxtZWz5uhDxBUjM0a2vnYzGQREe2bTYhcldjuzJC541d4i3K92+GPmHzraG5q1lNLbCxoaZo8L658Gm29MmQ2AQEqTm3RsMxnSJhWHYo33iD0vbI4UzXy8CA8lrHg15uBWNDhEU05Lgm1hGh9qWBJMloBJlOFAXnjMC0Ye8ZCgPXUHZGW2BZDDNeFfbhG3biVP8oFAbGStj3ynT0w2bcX9Oqm5m9/2NZuti6wHpFK+JC5h768lpWymhyk6aeNmWxkfQPa7oMqV4F8iKQRAZamzsp4XsVtOnCOXcGZPFgk3ITNXjtFjctxSvWdvGjJwbGyh0PkQvKeww0Fe08B4krNtr+ygbljQMiMrJCHyG5qL4
 qnXUTbHa
 KfGyaJ9Kmij3REfyF5c0PmxF1kkyoOxEaPa9yQ3Xt8yy5LbnebbQDfj+FNg3z6Lt9lmM6ApQZl1ytjkazulIfpmE5ai68uz86vb0A/VXqILoWreJJt8R4FTRbrUjLAsAsCOOa9QwC+juhIW6ilql3VAaJKHlQ7sURa5LJhqSuVQLy+p6sSOB5aH//jifEJ34VaLRlNU4SzzKKrI4CRY/XyqtjJ6993Vc2fIleUWXvA9caBO45FbeRvo58yYzMBo4rkMsetC1fE6skacxLt+gqr/xpck8bs4uIRB1Oy9mU54R8kwptwJcFHRnQljgnCmMHyC2gKFjlXzdaK0xzryMDB7dlaY3T+jfMRNKSICOjGPutY0B90Xm5Wq+H+lhwCcH45SkJAkvGj6jNlmn92cIsXC3M95gtR5jDeanC9AhuZemCq7+T9FfRLiQsEBfSRCTsjLgXYX5uJTvDROviXKn9sep2+Hk3NnniRMU/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026, Mike Rapoport (Microsoft) wrote:
> mm/cma: simplify cma_declare_contiguous_multi()

Thanks, this supersedes my v2 series. Andrew, please drop it if it is
queued.

ivy

