Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80F11C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 06:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F456B0088; Mon, 31 Aug 2026 02:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 530826B008A; Mon, 31 Aug 2026 02:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41ECF6B008C; Mon, 31 Aug 2026 02:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20E106B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:33:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97BAE40203
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:33:55 +0000 (UTC)
X-FDA: 85160599230.28.76DB21E
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id C29F7C0002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:33:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZAqy9phT;
	spf=pass (imf10.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788158033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZdYVDo7588sL82RPlR1GkDzeflr+52xwAeMcbvupztY=;
	b=YgctEUY+CM679ZQHPgXmvbCkT7KlXPcspGCaXEEgTi9z0BHmLjnAYUAIjLOzAIJtJipXE+
	23aW2Njy49/mOpu41mCoQALy7TmXMDVgO1iwkmaRUFFqoA6E/ttydPB7WBddHwY0+fDtBz
	bGfc7qkzV7g2V8aVoIww4KIQXcMgxsU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788158033;
	b=dcnOqOiX/nPDXPCrP94+M9MghviD2vYD1aYb+39CE4/bATl5ETyLSLhjtdlQdkkffDRZZm
	OvIqZmWhdDwWY5cVx8eiVMIMa4Npe7nB0bbSztbpz0OFwzKV1bWCOy54HQMwqyotKiuK50
	8uIia56saCYX94XPS2LrdUIMjtHcc0g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZAqy9phT;
	spf=pass (imf10.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d6f55a7089so31455965ad.3
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 23:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788158032; x=1788762832; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZdYVDo7588sL82RPlR1GkDzeflr+52xwAeMcbvupztY=;
        b=ZAqy9phTnOZSfsM4Vv2MnBIIJvaG3bLsHbuIQ0poOhrEkQW4e1oHcmUhzdJvu/xLAe
         6oayzcjcbPY4syI+UPFLt/pcQv2SD8vMrZk7H5tTJ7PLopDRAZcjKEI1tnidEaGjmzRM
         lFyRktOnhYlrnQaAIui265Yx6RP8/4Bs0U7ebNgRQhc3ByJTp8iGXPNizL6eQKt3yoJY
         ewiI0FAs6FcjOHTk0FBcqGGgtDlPwosdPW61wNf97jAAs0/TTMZloIJ/i9+FbYXyPRoN
         a1nwX+MdU0ykrrA6Qg2qFTFQNSLF1a/MENDKYjgRRckA3iPBXe5ZOohE2brntg6ssu9X
         KevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788158032; x=1788762832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZdYVDo7588sL82RPlR1GkDzeflr+52xwAeMcbvupztY=;
        b=NiMn6KH4nB/RbYHm8OlR1nQOopAYWPWy3MCv/DAiExzxIKi7UHsrw3JlVC0PGBFBJ6
         AR3PV15+sAB5kkZ4I8ZiCg2lhmbO1SlLlYAHsxog9Gbk+1v1FQdBdJkOxDfJKixKH0sZ
         jNjHdSV6TWiUqrCmhHDBpMeUzY7teGgGyJB37z7vvP235HYtNdccYe4YylqxZ1bzH/OH
         Ai18ToUXrBCEPFdeOw+BBwZvCKbTitg8yK/qjjeD7j1a4sqU8VvfjlslvjeXVE8rBCSl
         KpvDGRYHSdYHPQntFYZ3/T6UrT7Tx823QsNOYdeL7u6xd8MMt+5o6SRNVeIA73fUwiCf
         YtSg==
X-Forwarded-Encrypted: i=1; AKwUvBx7ksDpmQ6lkSabYoXdP48GlHjllu6RXSbelPicnTdPeH3etmmJOkYzKOBPlalhtWOe/tZm9P8wiQ==@kvack.org
X-Gm-Message-State: AFuF++lmpKzPsgA+hFgTFDIc7xzGw5XG/4uFF+6Ea1EKLBWkiKsr/CZq
	U1/ir0BSOd/yBBRnwcW3cPhgMGX6tB/PT7n4UsytzJqf1TJNMOvDuQ3+
X-Gm-Gg: AYBFou3xDP7V9IBKC9x2YyzXeKBPqHtvaQmRIZWOaxblMZhThv8SsjKviYqC1SGh86d
	TTmh8bfM+NwQp/xV1gA8zvmrAqXojHY1OXMHbWnqYDiOH0vNHqucHV8SaM8jqi0y1lViwTue8AJ
	QwUnuhS1w9S2NHxl8vQYn+eWMF8OZ2Sq00zZZCB/DBJw5zFQoHtuUCOYlxM6zZ95DZvBxYxlQqK
	OFo+Z9Y83/FEkP06kKut4CCtvsJ5vJ6fqZ/0l5+QYWavJlN1v7KN5yyg2TtaWqBWo91RCENe4bl
	JQZ+pp9mvEKBml/gG8x9Ep5aQ8ikAM8JjxoVjASXiYtuWHWkAN3/IooiEhUnn8FKSuhuE+8/MMX
	QNERRomI5j269fePpTA1dmz+irNRojSHTF6kXVe8RzFyLJ6onQtljLJUhvK5OrkNeWoH/kYx1JF
	Z16nTpws8mAEU9vLHvxv5KDeyo8TpEU6Y/Mop6ydFswgxP15VDnGDz36UQdFeA0B5CgG550hQI+
	dBzJvM=
X-Received: by 2002:a17:903:286:b0:2c8:248a:5dbb with SMTP id d9443c01a7336-2d74dcbe867mr391007535ad.7.1788158030880;
        Sun, 30 Aug 2026 23:33:50 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:21dc:72d0:e0c:d445:c26f:9091])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d75963bc14sm29404725ad.32.2026.08.30.23.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 23:33:50 -0700 (PDT)
From: ThangNN99 <ngocthang2710.1999@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-devel@lists.linux.dev,
	linux-mm@kvack.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>
Subject: Re: [PATCH v2] mm/slab: don't use kfree_rcu sheaves on PREEMPT_RT in kvfree_call_rcu()
Date: Mon, 31 Aug 2026 13:33:44 +0700
Message-ID: <20260831063344.7933-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831062054.319EA1F000E9@smtp.kernel.org>
References: <20260831062054.319EA1F000E9@smtp.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C29F7C0002
X-Stat-Signature: w3t9u7aqu9jqsrzint8t3zjxxhki7m64
X-HE-Tag: 1788158033-697897
X-HE-Meta: U2FsdGVkX1+du+u2/hadYIK/hNwWVJNheLB5GCW+0En1i2THeAZq8CoeaYAmQM0cZcIOcg1SMKNW6w6Q+HyYNr8riAi1cT/6mK2BmGaUzr+/6jK3buy+Fkfajl3yHN+our0IUfZFq3UpVBgHVDWjy9zN10cC2S3JbsvUGxb4o0boApDu1qqhG2S1A/jb6263+iirb5nsguPkGkjG1f412s1YUEmLGNGKIQr4UgOFUaw4vmRQxVpvGbxVdHmt3rTza4DKcRUx3XH/9vn/lN58X641qsPGzhdOQ3BeLErvvfXSx00ePAyLUDeH6NX2hNP/3bhEUWZFVRqsHj5zh3iX8w22kP/hRGnCKdx1OKIfKnAOEnQudSk2rsDLyM/MwrbU4zeJbRGG8sAPSKY9+rmlsYhq+DsVORdQHrkRcY+8rKpmahS1hoVQsjMdJv9fB5Dy+8CTntDEh4Ge896WsOBY6kaHtpO/gfdbCLR3NNJY9XAQJolUoMDHXHHE7t7lBn9XKIjs97u8V63Yau4CkfLXWZvL76zOiZxSwJw0J5ol1iMvZ0zHXZlJmuiZai7abJbbpsKSSuIGHj65ZsPzvAmWhEIZo0eT1/5Z6BfmtPrtZ/+U/7H6bznFRuYnkVpYsZ7Fw8kBeQ2fzo7C0AFOrzGB/CaBUpKPYY8IK92oK4c07aZuM8twtbL7Eyu+/5PxIi+Kn4NMh0ljfnrL6eV73ik47D047Vt0+UcJrSeXyCffOIC93O3Ohcn+X9NCqxQ8RHAiFE8PTnRA7DWPoyi8Lsxo46Nwv/R9IrTekrOT+zGeiAU2paXrgzlEj1gXViApUXERe3ga/eK7VP7Cia7Mgz5iuzHNnzm5gywf8I7pLu8YLhA6lXcFB2BpQ3lHtuPQur8FLmccYoxDB+TUNBCmsfmfbLErF1pvd4oB8zSbCpmTVvfWiOwz8nMrNEFEtryeZA86Yrelvd+2UiNJQIFC0UW
 JRjACfHJ
 E22WWxKhlWVVHnPzs9b62DoFuYYUqkHciNZGOdAOIpmqBJGnbaxzaCPV1dJ4z8oiFt5xBVSOsIDVk8f1+6kcV3nu3mru446Y3A0P6AdN+F7GQz7XQXIRU2NVl5ny7alakmpPHBcLH9DU+PK0vRoix7aXYAIE/23/SV3G3lulxxW8IfScZti5OUWa9/JuxK2zIAvBu3TZly5Sz6aOayPIqdUnq/z3H29tpAEbKEhZcbNT/dLUt2R2DOtV7FGUvIA2reUUm2FA9wskhET86WhP+qsLaVVXj87k1klR5KMEZSssnNKNJj75X8sT7/Ry2uYncLxtz+RGfZbW0BdBx54LIIQXimvvdg0PiusJuLMDrg1p10X8iHfI1wJfOHgnYvLqD/HOXMPytoN2GITLwP9NAjU5naYGX8ThaeQm/dTRrgouAPqghk60Opu/q/eSA8ge0bt6RkCJ9KkQueJ7hTi/LA+wm0mMMAb4H8Mr0gvnds+L9L5JuJXDqooO5shoD6+tfWJxFm2ONIMWuvfY8vtqaNC+Yt7Rap+auJ2jX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks, both flagged items are pre-existing and out of scope for this
patch:

- The headless kvfree_rcu(ptr) might_sleep()/synchronize_rcu() path is
  never reached by the caller this patch fixes: set_cpus_allowed_force()
  uses the headed two-argument kfree_rcu(ptr, rcu) form specifically to
  avoid it (see its own comment), so it's unrelated to the sheaf-bypass
  this patch adds.

- kfree_call_rcu_nolock() still hitting local_trylock(&s->cpu_sheaves->lock)
  unconditionally is exactly what this patch's commit message already
  calls out as unsafe under a raw spinlock. This patch intentionally
  leaves kfree_call_rcu_nolock() untouched; fixing its 'any context'
  guarantee belongs in a separate patch.

This patch stays scoped to the specific syzbot-reported splat in
kvfree_call_rcu(). Happy to look at the two pre-existing issues
separately if a maintainer wants a follow-up patch for either.

Thanks,
ThangNN99

