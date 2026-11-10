Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06828606A327
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=a9W1rheL
Received: by kanga.kvack.org (Postfix)
	id 303E06B05B5; Tue, 10 Nov 2026 13:36:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB016B05B6; Tue, 10 Nov 2026 13:36:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218776B05B9; Tue, 10 Nov 2026 13:36:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 063EE6B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:36:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9330D140A37
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:36:46 +0000 (UTC)
X-FDA: 85420065612.02.DA04A8F
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id B5DB52000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:36:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=a9W1rheL;
	spf=pass (imf03.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794335804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nq8v7VJ5VqpFS97EP72RtDwjUZHtXRoVpvPyoM9R8Ys=;
	b=NHsNFLmgfh3X2H/jgmk6CJipDtW70VSkS+1r6c6wZwTs7UtGzstD6UeUfj5T5tR9n50eu6
	Bwyd6m12hE4QpoPap3idLed/8oMe61ruulqXJn8bY/SPV18RHMpo+qNb7l2NT/1jqtjS2N
	sBthcQFe+1EAZYG1paSk11O/bWTcLf0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794335804;
	b=x8I7z+EUDmYLUyWoeoDE/3bjX26elL8uncMamaL17dyhynScRoH5Usfk731d5geANO+3Pf
	FQu35+FtRC9avPNCVbHXSlivuvdsz+LcHEpBeGnnmw0m9TwlHAbLMWAPYX9uKyuSIZVUf2
	rf1nDj/58Tk2kxIFOE9b3+Es5h8xXkI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=a9W1rheL;
	spf=pass (imf03.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e9f6a16afcso3335ad.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794335803; x=1794940603; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nq8v7VJ5VqpFS97EP72RtDwjUZHtXRoVpvPyoM9R8Ys=;
        b=a9W1rheLIRaT6G45Fox1Fq91vZI/+LuPBx7GfnLwimx3y0d8pwlE0noNCGeLA/Htre
         blBZ1e3KmWsY6MugK6Cv5QtvNlsKKbl3dJthim9HSofpWerZ/QCp5RKMrE9ZY9y7kCkM
         SPciEFfE8Its0MyTJEtETRgO22R9QyNnM/WkObVBWsoq0Ye9X8H4dGznxRp/UbUW++x9
         FlB7a9vAjPaepZIf8n3CwoOCfX/p/a+YRDqumofSD62r8gKoFHVhNKDfGZqNqdeGqzSP
         ENE9x5XZn+C8z/FDbERgC5ePeg3XTW2aLv34Zdm5RyjzJpAouh+VOuQI3Nhm66P36LE+
         AE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794335803; x=1794940603;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nq8v7VJ5VqpFS97EP72RtDwjUZHtXRoVpvPyoM9R8Ys=;
        b=boR5Yvae17eajmI0uZtW0zq1Qq9nv9jBxBEDh1BQnhhJTB5ZHOOouQZ7fe7TvhKSaZ
         2QBDPDCkaA1E+/qnF5LIGVfg5JBctyZWNc+hZUl4jPDUBGHVF2VmZYDK8tq1aS2rUHSQ
         baAxudh46tK3NtmTkHWoYLMkDHZZSc3tCphLH0bEhCov4o+GLItb1xbIrsTtisfFrY62
         p6bAvWjme7q3t0hn9D8JoKJj3Ji0mcR4xdMDWQWEJrPwcYgdYmmRL8pX4OEsrW1Y41Qt
         JY1Fa9OcBPM6faANdj+D0jBO3522sefysmLpUFyDWsobNR1xYRAW9LZHW385gW/DIlwb
         Jyxg==
X-Forwarded-Encrypted: i=1; AL+hErHb6ErVxrG69ZzmRdhshKgHyvP1RrUfOVLjiS7zPE3sindSjYI5yb3p4tEthmOcjp4WZmyabvw4ww==@kvack.org
X-Gm-Message-State: APuU4Z+9xFJ90s5zY9GJQZaR8gcOuGCWyq+bdzJi2KNCwOUePurqtkSK
	hV3IYSWXtl3vfKgG7Ri7p4KTDH4PPze0lsKrS1gxqf2EogaoAvLoS/1RM50E8b1hjA==
X-Gm-Gg: AYBFou3WnphmkDFRBzG2etLVLM+Je0/jLvEAMuiduM03y6qbnbb1FbcqvyO19bHX7U7
	QFjf0WnenB3OLrK+PsRt4AtA+/Dm+NHg73HtE5jVqgBi1XpY/xNnVWbBFrKqDBYewBlozkklaVP
	f3oPYU3ktKIAZnjZc5PvpyMODBasfZDStalz8ox25hW60UdhIRB2Ml15jSbxEzpjpHQ1fDxRCPS
	TeOMlPQ4lzJKKAw5Y4kl5FsFvHjgp5lSM0gPuD03nSim5m/nGV4J8dxXi8m0G67V6d5+8jzkgwQ
	PE8x1Hs+7g7t4N9iXF9r1l0g56DPRmUI9kn/lPQw5GAF3f8LShsnCfuQN9Zkm+1FhBcBVMhmw58
	gzK3pyB3Bh/BLwMNbHkokYQ3mUkRvpsnh4RGKNwuaE9pSUTgsA1GzZKQPLMWyLtU8Mlu8uZSH0g
	9zgKLsKT37BoZ8cdQKiz2YGOKfvE6TmydY28XkyjYyyO8wVIAGYul6Ak+U0aHqxYhZaRtEK19yY
	3UmQ337qHmezAcK9NkxlBkzjlq1f9wGcAGolL0hiNtxZEtzrhqgWlJPNCHQqEhD8uIDtYDeAUmw
	UAyu4CsDXLv89j4T5Roz4vuWh5Wx+fiVoE/L2T2glC2aU9zkWNVNm4s97PTi07o8DKaR7e+rs8B
	wMIJ2D9wx9wwZnj5ZiWuZ/wqlAwRG7Y0zhd6UrD72APE=
X-Received: by 2002:a17:902:ef50:b0:2e5:9bdf:6b65 with SMTP id d9443c01a7336-2edd6b65b7fmr241375ad.0.1794335802929;
        Tue, 10 Nov 2026 10:36:42 -0800 (PST)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d7bf46sm12827355ad.31.2026.11.10.10.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:36:42 -0800 (PST)
Date: Tue, 10 Nov 2026 18:36:39 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] mm/memfd_luo: keep memfd frozen until finish
Message-ID: <avNkLp6z8MUdjgRc@google.com>
References: <20261110175855.2437084-1-pratyush@kernel.org>
 <20261110175855.2437084-3-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261110175855.2437084-3-pratyush@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B5DB52000B
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: a3rbns1neokatyqb15ck4eumc8jj99xf
X-Rspam-User: 
X-HE-Tag: 1794335804-655857
X-HE-Meta: U2FsdGVkX1856kR9Np8vMN9Rguhj9aJVj7dwx6AWwrD6G+hld1HvJiDZdzs1ChyUpU+wjVafXeBjrDk0XxYWC30co7cqvJmV5m5I8LsIWTxdsiB7Dvwgx1CEbckQOvzwpWgoD49Bgup+g/wzrKa4x3mKGsAdMlcWnTVB2I+APMhXEBcnjGxtn0vXfBVt6CwhFl4w8avKs8nx31SmKcq3NnI53G369ma48k4lUPk2qGUC7S2NHpKhautazEtxy9q72GOJRpuKRHoZBR13b/C7nMAuTXDFoUunfN3JYkC0IZ98dD2UWkwCzSkNpIGCPCGWBj65rA6T5xQH5Ba7gjk4QTJKqPCnsUtyHou+Hu7KHnHjhqCqIMeFhrEBZp2ElCJdwfGkEf1Z/YNkAIQYZDNCKQA98ByeQsVwbgFiBc35YUXngqhq3kniunRxBhYV/dZu8dfL08b3DwnHfqDH6RHx3ieGfINP2RavMqKKRPjLhX0kZ7ol4stORFF6qwGAK9Qezg8ooUqJR7EA2zE2QnT9Uqpwx/pfL43k7Y6nJsVzwWZ2kYJqEEBscDtmDA9x/I13gCZcHFGLnIcPIB5kAD5l/GZwZJHQ61cz9ot8imbl4NU6tIF61mlEv7y3mciXC+Ur1/Rl7LDITp3Sq/+ZU0FEJlfu91YsVszxaZIN+XEC+BCXfkwSPICmDj85qug0+jlBzlPOivOCYRRUEFnpajAK8Vy/AMCOOE9rKpMCak3+z9FqtNC+KGeJ2KjBM4MSF4s7Et3p/DNNP9QWckHcgSS41Kt4rcGG4SJ3KIfsDYUFkxs1b7PmHm4L/tMm8Wo1C68u1cIuVsgA1xgJLCGtwTFJawCx+3PoC2mdBHo3GIgybhPhULo+83JiFwUFnl7uXVCscZhpHJ/GTW+YL10KcdGfG8OHgPBBGlwDn/vt/n6p/D+mB/ixMRPA/SIGAWPLvfG/7jFhfnurrrKZMUi3mi9
 qBO5PKif
 YikfmZcbxuZag8z9bGkZ4yv7rHK19N7q8XCm3Iw5/PH70h9QtdOIU53ZLHk7igYxB8mZJMrzL0ahFGYzwD3ugd8DPD2Now5gyT6YeP59/LiL3wS7DgImW0btSCn2c45yC41GjNZ4JgD5jJjc/bluddoMcg0I6PFjoNxclylDix/JfwTNKrd8pHP6I1kPYEXKC232UzbUGGhVBRhSM0tlJOygej7WdZVehWWaTbVOHri3DGWkUj7maI+o8N0h4h50MLqLFb/cbTA+RO0+JPqYBb4H7rv6lSNI+M2S/oToosSeASLfDBprkD3+Da4AqRd1DskFwb2SqTDudQdKatBqis20X7tWTYNuyoXwqLTU8XhVLlDNMCDFYIN2UXbmBiGJphXc69pRJJdryBIYmqBzlpsQv+8Hc3vIBTqA71LIZk413n36djLsQQHE5kqpvIxRLB/DkLr6X0rU6zc9MH6J+nhDzKB57Pcyp0dYW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 06:58:53PM +0100, Pratyush Yadav wrote:
>From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
>After a memfd is retrieved, it immediately goes back into "normal"
>operation. The file comes back unfrozen, and its pages can migrate, it
>can be truncated, and so on. If the memfd is depended on by something,
>like iommufd, that can open a window for folios to move around before
>the consumer can re-establish its references.
>
>Finish is the conceptual point when a retrieved file can start to behave
>as "normal". So take an extra reference on the folios and freeze the
>memfd on retrieve until finish.
>
>Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>---
> mm/memfd_luo.c | 87 +++++++++++++++++++++++++++++++++++++++-----------
> 1 file changed, 68 insertions(+), 19 deletions(-)
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

