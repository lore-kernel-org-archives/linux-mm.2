Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ABCC606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 01:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=kZMIZUK0
Received: by kanga.kvack.org (Postfix)
	id 0AAE36B05B6; Fri, 27 Nov 2026 20:00:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 062136B05B7; Fri, 27 Nov 2026 20:00:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3846B05B8; Fri, 27 Nov 2026 20:00:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79CFF6B05B6
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:00:04 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DEF21C058E
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:00:03 +0000 (UTC)
X-FDA: 85482721086.24.6DDCE2A
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0076EA0005
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:00:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=kZMIZUK0;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf15.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.175 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795827602;
	b=6Pw9G7EvnugJ7xp7lWV7bILIDq5LsPql4rcjFmqEOvi59cn1CcPN913PJrVuymNdbGyDgk
	dXJFUk9EZHtURVSvgYbHedSu9cHXghgKuMq6ekcbxxK6aOQDwf1ReGj8k/ymcaqCEV/zrE
	jqJA6usMWH6aXyuDGyxX2r0NCkfDnpo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795827602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4Hzxb3NGCSSYFn+Gm/a38nZ3OBSGBwiKOcgfEfvzmI=;
	b=6/q11qwTl+vmq5G1sI6RzfwabolG05p9FCNLH9ewr0/KBr4eWMGrBd5+Ns8t2FqJTdqFzF
	fBGogZwwsLPVGb4uY1llPnD72Q6ivazm+zDn9N07wNXF0vbWQ1t3GPRIwTJTWcFA+MVwnN
	OA8SmLm4jhya9oplhm+YrPtydAyovGU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=kZMIZUK0;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf15.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.175 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8b4cd576f2aso62868707b3.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795827601; x=1796432401; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r4Hzxb3NGCSSYFn+Gm/a38nZ3OBSGBwiKOcgfEfvzmI=;
        b=kZMIZUK05MF+x3d84rtDSOPCgHn3vKbLaJYJYuG9V2nSCvKmO/SnICHIacxQyyh4wx
         793UUcjYCbVyWhlXFgB09zUW/hGhEWpDMUYhRxt8tfQn69HM3ypBQkhwFb4+7cLdcIbv
         3gLd4v7cnzxmFfvXAlvbZD43uGl9b7YsxbhFo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795827601; x=1796432401;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r4Hzxb3NGCSSYFn+Gm/a38nZ3OBSGBwiKOcgfEfvzmI=;
        b=WDizIhIkNLB2/tUT+H3zflFbkUUb6+SZsC9r2Dz24tgdm450q0eJSrNcn8Iw76hXMj
         5irC2q35fzBBF4UMcr3WWCBCjUbOMnn9ajJ4t6juIkXLY8GCwNlCMszEmdwvB6qkiPjd
         XRTlk4UF3R3QqBHE0jhjeGPdvhcdUJ349Y7zHmWqJxmGuNjtYUkwK1XAwwoVer/brjcs
         XRx2VyYiQB2WWjDIIYUFd6Q1ilfSZcJJJTfSUY1d197jOI8x7FZtk0USPBd2wv/6gJ6p
         ENZcidnUg5mKIyfG0zIHrh2XuJz8yx8UNvFe83fjpHut5gvCLFPus3YxQLUxyaQN76Zg
         5IhA==
X-Forwarded-Encrypted: i=1; AL+hErHmOa11JSmkJiuPL2Xz5156fJGPmSxV0cDcpNfG6qMzHqb3HVSBgmEIortKNkISyWVhv1141Fq7jw==@kvack.org
X-Gm-Message-State: APuU4Z8qOlTcqSH3mU5B19FMGY4nuEW7g6MyUeI3ZuISGgJnenzc3UIf
	V5XrEHDPh+ZoazkS3U7HrVaflOS6PWW8r5KDoF15cbpX7YAuB3aAjdhjvY+JcnjjVhI=
X-Gm-Gg: AZFdTZenGg88YrxkEx9u+XPh2aFfdlS9+IGJr0F+l3B+JQhLTLcFjivcr3Mhn9tuxtn
	6DXInKpqk4LShMTZi5W5ahpehdk9FqHB7nJOiBw7VIFSSzwKAlWTI+c/ED9O6/1v/yI9cH2AGGY
	5yMKnevxMKevFkVHuM8geT0E9KQMEfRuXHjw/daIJSPl/pfF0p3di709eaGptzX7Mp7FtHMlDhw
	lzE55h/IUiU0iu65wcwmb3DZzWv2ECc/PdHVsdWpdc6ThvFEwTiWCPis3Gn3exG5ZQIh6ESdtHs
	k/J9fjXNIYE0zckkwzPtA7ZbSCs0St3ztyeFp5fy/0BuNMG1PaSs5r/q6CDIIMcrJ3n8Jql35cH
	Fgfe+i8FSLLxYGd2qyKrTkUPxJHumXZlo8q0ilmYauzCbRSfysDcq3Ptz2zbXE0fGUxGL1pgade
	ssPj/1Q1bRrSm/9dabBbTjPdamGKd/kLXnFlHwUmN0MMomXa3vb5MMLt1k8EfAq5diWqArAYGtP
	UaAMShZzNSmkxDKVrK+0iUJHSi79mpdrG2eUiAVDPebyYG8yFcT/dQ7Rb9WhUjpS4LuW2XvGttY
	YyuMKwBE90fT/og9Kz3G7O59rDTtjg/6q6zD7TyKlrLf4Bf6HwojtOVxNQE8XqDMsJKuoSjzkGZ
	iKpAcYTy19RJxLoh6SVE8heu8WGDKBzIQZAv7aZa/sVSnoZOsS8SYEg7vC9RLWbg0lUQHAa5G23
	mJqDnmk73SWKc9ZpwqdJ42bYkRRP3dWL4RLQBcNh68QelGbc/gNhcdVA8k2A/OSqewZlQM/cftL
	3DIvfxtmedLoG2UnyLsk2Q=
X-Received: by 2002:a05:690c:b86:b0:8b3:4911:2dc1 with SMTP id 00721157ae682-8b5204ae0e7mr116512127b3.39.1795827601141;
        Fri, 27 Nov 2026 17:00:01 -0800 (PST)
Received: from [172.20.0.2] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b5202bf474sm101002207b3.21.2026.11.27.16.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 17:00:00 -0800 (PST)
Date: Fri, 27 Nov 2026 16:59:58 -0800
From: Chris Down <chris@chrisdown.name>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, David Matlack <dmatlack@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH 6/6] kho: don't reference subtree blobs as FDTs
In-Reply-To: <20261127122536.3708770-7-pratyush@kernel.org>
References: <20261127122536.3708770-1-pratyush@kernel.org>
	<20261127122536.3708770-7-pratyush@kernel.org>
Message-ID: <awonjgkHO4wSeAGO@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: baxw317jm8makx47dx6rodtp6g1rfu45
X-Rspamd-Queue-Id: 0076EA0005
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795827601-604395
X-HE-Meta: U2FsdGVkX1/m7MqvXPjQEd7ix+Sw2hyaTK9SupC7jUpHqcDDd2aWQ84sstAXmpQjI6KbZsbI4uyxGkI/nSZQssH+KHTOFKwOJm5MaQnbRBcqfZasOT2VuNWcFgiE6zyRMsKD8WR/+E/qOJKjYE1wVUWGn+ODvNFlcTXReBaP+p2sAKJ1m/jYivfjN9h/mozfOCdOE17L3nZ62ediZEOaSkH0KzaRa/4l7JLqAbudJw0dD1oEetYJugvX+6CJEritUtj6KyiQEMBwTSM45ZETk9663CvLNCLjQ7buoPnOn0BYKph2vTNYAg3RIlhjyUDVXBdeLXcgltTHXiSnUD1qelGNUspHJrYRgxHXxbA5j1QHcQA9Tia6hE4/WbC1wRtcEZCja5cV0ViReMpszTpxiuTUMVfRmqIxFoeBpMfOZBB8hTzt2cq1RJMShXLIL6lvFa9E69qxXrYnroOYOWT/VV7vYYVnfo4TMd+Dog4ouylZdaBU1F6esycRVEwmKmAbfz07zWFMCBSc9ETlbZOpCT/HnuSNM15f1qdrYQjppqEQUFE8kF+6gKx5ijUGzavYE5pZOo1GWCj3EbDMzUPIgfcX4Gm7Onicktx19LrOdl5DuXyCewBw/1DR8SVzel/Sy9lVybMBo9Q+AK//kj/++FdAUTbNAfMf9tlHYUHRbNgqc9ghmzuyPzW1m7HhvXjuO7D5uuigybubZlrn0LH6q8R1q9agl/NenxD/B4jFIdSVf7bsR5QsvMmKdZUXxgPxZlBXivwetXPiLrAi1yNSicamXs1d5+bhSLGJss6WY/RMDPhuCmrWcpNNOuP7zQ+zqVbn9R2OaergJRd+ykQGFKgIyaEPt/5DOyo36nv+ZJKOhXqU8pHOLMXnup342gHDMdYuHvqw/3ZPiCY0otqHyxUYdHyXRRTNnZjVOrrmjZUq2s0B6okDjnYL8v6wRSVlzUwE69OrgYYDzNUZwYX
 ZWUxguBH
 ZoTCuMdU6yqG20MPHuB6/tllJd0ewqEDfS3GDGSTsDNK8DN3hSYHaikNaDTHUGiEIMYPKwcu30aIBVZTh91HKzC9sKb5UndUwu8rqw1fw3l+aq3cN23Aan5QiVZUKLdmBrxEMcaxRWEIVykx4ZBRl5gk9Gq+1nIwrVtCjmz9SZ3l8bF8q5IgeyeprQ8ZINVBz3Vp03JxzH4UiNNc97JnChsdzg4pcQPw7pfc8S+Dz+pJstqpcYLOmeMSccytbzqPQ1t2UakzUAZj3VOBVMfTyh4SSad2sIfuu2dzePUQYoC63KcZzxWECOdir9WfrQiowyiw3at+ZydZUgiClCUbApT7TR0TeXf7YaAqYVby6CkwSnYS+vD/oM78U0BFUn9zgB9DdTJz5ELLvqWHdT8nKq/cQPxksDNMiC920lpsDpkBuihf3NJvfK35knTVM2XfgiQJVGV6pAEMq7xMWRe9MXtUyn08mSwxRuj8h51/xF2pFug9kAab3RTUYCmQ2pZj7LGbGGMOclsfTcddxXGnMZ9WP6iD6ovZRCHo2qeisEluJS+dbbePwgJ+/q8SUiGwPJsS0KJ1TlsOgqtsi8t0snBgYApp853vwBJLyjT+jfyzK1L/bnNIfZCWXsGNA57KTJ1h02cV9IL6ORmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Pratyush Yadav writes:
>The only functional change is the rename of the debugfs subdirectory
>from "sub_fdts" to "sub_blobs". Everything else is a pure rename.

It looks like two places still refer to the old directory name:

    Documentation/admin-guide/mm/kho.rst:110:``/sys/kernel/debug/kho/out/sub_fdts/``
    kernel/liveupdate/kho_core.c:1099:``/sys/kernel/debug/kho/out/sub_fdts/@name`` when kernel is configured with

