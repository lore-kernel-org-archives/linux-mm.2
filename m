Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 829DE606A337
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 16:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=ArZb1CJI
Received: by kanga.kvack.org (Postfix)
	id 8C38F6B05B0; Fri, 20 Nov 2026 11:27:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874DC6B05B3; Fri, 20 Nov 2026 11:27:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766E56B05B4; Fri, 20 Nov 2026 11:27:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 58C3D6B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:27:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D098E120F7D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:27:06 +0000 (UTC)
X-FDA: 85456026852.04.6A9263A
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id CE02840008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:27:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ArZb1CJI;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795192025;
	b=VL40MbyD7LSkb6dcqaBe0YK1qVY68SaEa2IcIJR0ixpOrYuBJ4sh9iP7mnKwrZblNdJnya
	aHEDhS6R2Han01DIhf3cVhaq14IcpJb3KwAqdR3nnEdiEx05W3adhZv+I5tBZxcs8ldoeZ
	JoYih4n1GEJL9V3Inij5hcSj0E32Gjk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795192025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wfxDs9gzdmZ4E8B3qKbvflj7O0o4ha7gvjg3+e0Jgx4=;
	b=UyZrbAvjhzEkWOTRKMx6HKiPgv4jw3nhlrhmrzXHN2p26ztIJ8qiUCIQQODwjXWdFUyTR8
	Ujf6NRf0YmFFZzO1GxL9k3numrENERWHgFgOoUKEq70nKYwgYxaKuz3VI2o9fVO9oO91Db
	Jcv7C8YWYXcc5XkLNwd8KFmqjq8zqy0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ArZb1CJI;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-55d360ca878so9282241cf.2
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795192024; x=1795796824; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wfxDs9gzdmZ4E8B3qKbvflj7O0o4ha7gvjg3+e0Jgx4=;
        b=ArZb1CJIOs439uiKd9q6ZM5Ej3Ir/COyv1S9zL0nmv0vwSgAinwmNk2vQ3ID/TDO6b
         /Of2MIlX1NFrzA+XdBPy+0CxS84YCDQCTNTtNhBpTI6EvP11YQN4c+Ma57pi/GqmXWv0
         4ixZUM+uqZGZSBPFaITmry2viQBO6odkjgxHGsc06gPjsxHo3pzZPMeGNnzt/8vaBQlK
         iItyA15P8lkKKjE4Gh+ARukRfzkuUplKYl5NpTL8Oq8tUMjUWL89fA6zEOs5s03Vz4GC
         sOpbWVYAnq2QVIhqRPkcPy1FTMHnB1nUA81SdVV0xohpfIm+FAc6LmTM5hSyHZG8YJGp
         9dJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795192024; x=1795796824;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wfxDs9gzdmZ4E8B3qKbvflj7O0o4ha7gvjg3+e0Jgx4=;
        b=t5L3ORoOA6rIfZYJt6teBrPFp9Y5RcsX5bWSTWjtqa5Jg/1wclovF1PFbNuX+5qjam
         QBRAMFm/INmOY8IRe5KdT/ht9fqmvdNk4tweoq+vnQstXRdp99fkbiQqJeV8V4f9gR12
         JEMxqpk3dNt6PtenpzLcknTvSp4X7OnPZBXPtQTD6qU2JmMi7eJxe1xZ3p+ZY4ZnLdh8
         07PN75VeTgycxJuWxJSR50l/sJti74TzwgYAkg0ysy8D1HqmEDeVne5t+XSf1sUuTfwh
         SuOuZVSmHg9lTVY+RwvIKwO4zabIOEdS6EU4Q4fbAiQb/UTBZ+VQfP9mY+9voxXY7VDn
         ZSYw==
X-Forwarded-Encrypted: i=1; AL+hErFFugYo8aHUiGMaJSc83nS5+8PdNotI8xlNrWMjEn9Leu4UHrteLnnkbcpOuA4JFF9w6F2V6Knpjw==@kvack.org
X-Gm-Message-State: APuU4Z8dBD7kCjOZGSzy2PpgfcdY9M59sCiFx1aHM3fnjBLRIwvlm84D
	eERaoMu+VxX6sgN7alIEYIe3qGvtrDI9BGW9u89VvLh0Kp9ocuC31JF0+LH+A6EcX61nl3S1wX1
	W6+b0
X-Gm-Gg: AZFdTZfONDeGOWez3DQR4MJ2DB2RZm4D5f1A3eWupHGQ1frXClcF5jxzVzF0AyDO9bS
	HqC5757PUoRol0MjhjiRLof8X2/zh71r6HWTxKRWJAbcrTf1J2J+Taf0AOhi8n6qPT9uSMh+Nli
	LU47B/1eRWkoHMrZWqVREnIg6ufv/TeWpHUmVaInURTjawdF5WWLl+9lsvgL9yj0LCxBhEiRem2
	kIRvHpkEBvAXy4nAxYlj/IncKw3Wq8juArnB1sfJW78rgoUP4qi+Y9optbx8FcHoN4vJDuiaYTP
	WwUxjNiffF7c6iJZBVE+THTLS60wEXG0M404v99AeNFtLf2n2s6s3alp9v5cD6P7vc95KD8Z7Xf
	X/PQisvDc/oqZdLcWSCjr9ShkWF6BOkEq87LvIJeNIRgQLVTSctJAo01/KzOEydvWa7DZ81dXql
	qIbVLBnQzUHhZfP6qz8OkS5ls0YMsTuMfGjVFDlfj3L2nA5UnoC+v8OZDiiTQBoustV4aS76Ao9
	enNQthaQ5zbbXwN8YRbcQiDPEyiFVUMMUNkcGyJvpsti3Fvz0amsOYOpd6QaorDpxyKFALyHQM6
	ToF7s6G+GmKG80I6jQbuV7WApfdep8b2piw+/I9EM5Z7aR/3EOnDTTMa0b+U5XTX5meezXmBcK+
	8oaeEuec=
X-Received: by 2002:ac8:59cb:0:b0:537:59b4:3338 with SMTP id d75a77b69052e-55d76a6e956mr66914661cf.25.1795192023791;
        Fri, 20 Nov 2026 08:27:03 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d788ae02fsm25370021cf.29.2026.11.20.08.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 08:27:03 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] mm/slub: Respect MPOL_BIND when taking remote
 partial slabs
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Andrea Righi <arighi@nvidia.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>, 
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jan Kara <jack@suse.cz>, Quan Liu <qualiu@nvidia.com>, 
 Lee Trager <ltrager@nvidia.com>, Seth Forshee <sforshee@nvidia.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261119160430.1113397-1-arighi@nvidia.com>
References: <20261119160430.1113397-1-arighi@nvidia.com>
Date: Fri, 20 Nov 2026 11:27:01 -0500
Message-Id: <179519202192.412063.10960263756664574511.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CE02840008
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: gz8rqf7dbah9uujqdf58jbysybmap7mx
X-Rspam-User:
X-HE-Tag: 1795192024-357113
X-HE-Meta: U2FsdGVkX19SMKflMzcvucJKKOMmC7Q5FXCAVsSgdoo6EUpkK6gTHj7sD3mtWSS5XOmerq5E5uMNEBLHGFJfFZEMS0fk9c1WhOf+oYUHQ9d0tGl5Ro8JZ3JS0lnFpNR1VHNJA6yVqWprIJe8RjAljIGt1/ngDIv+meTzR2W3GMWayWCH0Hg7JPXWd2Hwh0e/EG2+jfa+oYQOKKxjiz7Gh2qpCZyF3gGmp3p1QUc1IWXK9GPiJts+eXxJcjpiZYdZzWK0Jq56fkaTMTA1EhXmGTPK+4Nr+2giUny/+POydrt45hcGDPGn/A8GB1aCpU1PdD9W3+B4EbVU+vDZQ2TXsfkj2d0YKQ2PabMPtfGSmrfH7ii46cEAFq0glu8C1FkDvGYtLuKoj7PvPqofzXa3J+s5mnfglbuSznk9LvSUcU+hy0dtXumZAWz1GGd01GvFqzVfbmnaCjTVrPLPiSKz3ZRhabTA0Pza9UaHNmhSs7VP0ZMu2jcB4kAt8fdTXD6lLUziMPMqvyh6fCOYMqEzyeHHK9xTaBCIIJoCdWA8toqC6Tx2/GsJu1nHg2KM0IsJIVIAvr5pdD6XwP9W8b9jQNAQTxoCVeDTto2WUbIuG1PcRFcnLKWrCg5Fn8ohJtvDVgUA5xCBJibF7IpxXMgwKDB2a1r6kt0lmPdB7h6JCEgg7A5ceYJmwePLMnIIw9ado10pd2KBorpsLH9qAuPvS250jKjw0MSoZ0x5yJvFQlIozAg4CNU6VbD6wUNAewwtMoYrJU9K+AvlGjoD9WySg14dJwnWanAJOF5JgZVrR6CfqA8d2TA88Kzc9mkDEyeg7e+ftrIXIlOpNbT+fvPYfsy3502n5pYjxInBlWdrhigitnAba0AzuvCjLuqcs6UwHNjRFAZ+ZJg/l8FVty8Qoq6YzEx9CD77/OjDQJ76URsMQ5NuAx8kk4ufJBU8W5cLbWHhsMoNolI8b7/p2jy
 QSl8+rHq
 fHYFs7nVv7WxrBI5X+WiP5qdnhTyKls5E0RKz1d2C30aIvdLT58JrSNlE8wEzHxkgKpxMIeuu7DhOk7uScEtaPTy8wBDdKolv6xVJNDKfV1VcHpmXVaTPAZtneoaYhPFFXCC88HMu4gbSsSBQWGawQ6DECc2itNgV8uadu5qIVSURa5TZmmkuFcv72zMGnGqmoGy5oQIMMtWMlLOwfKzt+8YYdA7gnw6gMbgtNJjIBoeI16hPyEGvXZKoyB9P8Lmgn8s4+eT1ELmyFjeVwGV1PZHpyPdi6GdTx9Em850UMoo7NKZ16qI5FKdTdGOL8wsKq3y5Dl3AYvyAhU8nViyb/FYcIubtxMTjhD2VKao022l69liPyBJ1n7ZtQgHIFNMR2IYeNWcRI1uGhrAIcfOegKExsELm50sUXHYkrQI8WEBzzjsewH8DKh6SuOow81J/OyklU1Y3mdfPtH7JXmwg/OzpoZg/x9LYppcfMCRHweIy5xzCGTiOAlCiDDbwQ/RW/Qy/BdMci+GeBSvkDv/j7+C1FrctqXLXMgEmL2oWyEN9aDk9YVZlBoqhHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-19 17:04 +0100, Andrea Righi wrote:
> +		nodemask = mempolicy_slab_nodemask(gfp | s->allocflags);
> +		/* new slabs for the refill are allocated on the local node */

hm, is this true?  I think it prefers the local node, but with a null
nodemask it would still fallback if memory is short.

Is that ok?

-- 
~Gregory


