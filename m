Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA136606B20A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=fPD7ErIw
Received: by kanga.kvack.org (Postfix)
	id 9A0ED6B063A; Fri, 13 Nov 2026 03:52:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9781D6B063C; Fri, 13 Nov 2026 03:52:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B56A6B063D; Fri, 13 Nov 2026 03:52:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63D186B063A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:52:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF2ECA8055
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:52:27 +0000 (UTC)
X-FDA: 85429479534.09.2859DFE
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 04B1D14000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:52:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=fPD7ErIw;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf09.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.177 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQBXOWZ0Jeg9Kyjo2fd5tVPCdhkMAv0V+YCAjxLdw8k=;
	b=xQb5Sl8ZJZmNh7u4n43HSbHsmabhhoVAE40CuoOqN0y2w3Ug02c0Aic7kqL31AgrRZZS7t
	TSNYl22ul4OraMMnnG+pYIklql03s//rYn6QE/MuLIDDkhumzJEgmCoX8+XW3gzVZWm0KH
	F5A9gVMqqtnYr/Ef9ucKX4InC0mxb7k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=fPD7ErIw;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf09.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.177 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559946;
	b=O0V9K1vG1jVCV+calZBhsaQufpvEZrHDaNMa4pZNHkZtg7NpPRLdi+cfirZhZdv/mTZirx
	w4RPjqyVEhdWSr0axZTgMDBJSJ+p8nkkOUrYK5mtG7kT2VR/kxi1soe28VotmXVXYOgzJD
	ML5FCVKEipA+AuKyCYLcacyPX5d2hZc=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e98798cbddso5729475ad.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794559945; x=1795164745; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sQBXOWZ0Jeg9Kyjo2fd5tVPCdhkMAv0V+YCAjxLdw8k=;
        b=fPD7ErIwIOIEwLS8GvhSTBksdx+vgcgLTgj7EKFYDKfaE0WGozH1kPsFd9vwUm9ACI
         AteR86kiIjoyBnlXJ72hAy/22B7n50SaXI4shJ5Q7gjbYOaGzwwBxXD+br9mbO9hv1+V
         u8/RZBiCRMY8EYSFz78w70trqV91O8q1Z0810=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559945; x=1795164745;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sQBXOWZ0Jeg9Kyjo2fd5tVPCdhkMAv0V+YCAjxLdw8k=;
        b=tSfFUHj0TEriYPiNF0IYjE6W+RzkwbVGJxFU+BpHvxm4TCkeldm54HxQ9zblWSi5iJ
         v8IcyJEk+n9Fc4Zufp4iPmJ0OKb0u2NxYFtQk4Qz/IDUgi7glODwJVUruJMqsliO6EmI
         5S1b+CkYWAwoLbtnDJqeGayfM439ijhjiEjNILFaWn6CgClZwk84kXDrtc6r+stzH5to
         cg1ZKl7Lx4G+WsCmilSnBNrijVAW1dEAGdLDV2meGt3gjVVvkOFACk/SfnDpUqw2iN4l
         NwtE6dQyc4WrHaB0ji0Pl37jmztHKx7OToD1KLvI57QK4Gg8RJ4c1H7Am3+AGN8DDqJq
         VMhg==
X-Forwarded-Encrypted: i=1; AL+hErHgqB9v3lzuYhlDvqidyu5pbTIom9Yl4NBwU844J3+aDxLSGucSVxPeu1o0mt/e45h6+LQxT9bRBQ==@kvack.org
X-Gm-Message-State: APuU4Z+wzQknR6ekAJN+omJnehAJ3IYPRzq4rkSWahYfOAMgieRBCyLU
	/qYjNbbsB4LP0vnt2qc3DEAhWWS5Ne6q2v+fJM3tAXYqVtE3KQTK3ZR8Fl7++ML3iaM=
X-Gm-Gg: AYBFou0Uq+FJ+3PHm/giT9PXG/33TIvmlar004KG5OJF/HvN392b8In8EYL8zgzeJhg
	0hNXzrFHgyo+WIW5gVdov5/GIXYt21L6B+DVPASMUL3XmZxFbYoi/Lp0/XvfCHOy+cBpQrocor9
	sjtONbNXkbSRD7WLuoifnBe13A51kqEmS8ekhSz+uEIVpJnhQU9ekzaXp/UC+hMcDdnpHQSmE71
	+h6fFxEbMq3eqKZ4+P6Y0BoA3KEjcY/80g3q2l3hfCfpHV8kvZLF8EFzcltApvPXvqMpKCtYMpP
	1TIfxWjD8mOE8Fb9Rq8VJLy3k8JBGQhFl5d4Rr3YLiwpMnKaoFNKtF7d9wSaLm2Hjb4m3t9WP6n
	FmZVhjwb2PLjFe1NAggizAOtKT0n4yRUYTaXIHJHV29Aw765n31Hg5Fg07j9/mr2SHej26CNATp
	ktaBNbPTj+x34hLlpWWIYmg69dQj0p30HwH8NS0TRa6l4/BdZDtdzTS7f2bK7zSHz60V6fog2j/
	Cxr0WeikFCtMCDkjb9FNYRaqYWyl7IZbHb3An6L5tpKg0PSKXjBpwpwe7Z8uu61pZmcY/PIP9gx
	IxQvd+54e+zJFGDHHD/g0GagU7RoCPEyhB48TD17RPnbvXjFMhAc5B0NcTNynQkc7Pj0Q3KOGoR
	rXm64nir7Rvqs8tdOK1uHy7W8PF4Fz7x1jrUTVAaKwOV9hwb0O77vt/I6cIsuMoQNgHpz6Jg3IL
	g6CtIVBwtqxB9E5II9fQWeO92r+ivENXVqdBH8ngjfQ7J7pcVuWJjjBkvGZUM=
X-Received: by 2002:a17:903:8cd:b0:2e9:5714:608b with SMTP id d9443c01a7336-2ee0df40edemr17713825ad.34.1794559944843;
        Fri, 13 Nov 2026 00:52:24 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f75b472sm6940845ad.19.2026.11.13.00.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:52:24 -0800 (PST)
Date: Fri, 13 Nov 2026 00:52:19 -0800
From: Chris Down <chris@chrisdown.name>
To: Harry Yoo <harry@kernel.org>
Cc: Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Marco Elver <elver@google.com>, GONG Ruiqi <gongruiqi@huaweicloud.com>, Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 3/6] mm/slab: Support disabling SLAB_BUCKETS at boot
In-Reply-To: <aud4gPOUzvHtLYnJ@thinkstation>
References: <cover.1793253633.git.chris@chrisdown.name> <9a68a4d95830352ad3821437c2e22c30a673055b.1793253633.git.chris@chrisdown.name> <202610302115.8C7AD110@keescook> <aud4gPOUzvHtLYnJ@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261113005219.f954ab03e886b1c3@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 04B1D14000B
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 1szces97gqydttyddh47y3hwok1n44be
X-HE-Tag: 1794559945-29119
X-HE-Meta: U2FsdGVkX18DB1viLj9lRj8SLvxqhdKIsgqqETyJgTw96GSErPMv74VTNHfCmxinUYXdVoCjWvyGeEiT6GK7tgLmxy/jWpCu0rQJGdCW/Sn307Wvt28UhzFJPyYtfhvcKJokQFngMHHCLjDJueqkPrG0oAew3Fkd1L6gJSJ/im7odCQu/pwTL7yl+xwYuXk0nFZfDA8oW03RNzNadP99612o+70rd0d7keQoNGmR64NzeUtxnsvzHxPAhSZl2eix4xlJKyixAnmsn9rotwGjCA2c3wv20j0ke65V2SRWxLFfHfHq8l0mnAyOrUZ3im9lZDa9k9CvoticzqS3TITzkBgzpX4OeVYidMv3ovfkxqqbquenp2AKp77/zvnPp63kAfnUMRBQN8jPdyKG6+cqH08GIM56trJXT1CGJ4HXE/gSQmtxfU0QEsPqw4SOS/yrGciTSplbqApEc7IGOLHKAGk9i+zUaLmopR2Fau5gkvFuGP5uZXypkdjX9pJgdk37zPObSr//CSqCGFnrsk2kT/q08gGwyqcAw8x2eQy3O+uItpEWiWIVGdVxlY7wk24HhPeivdXJ3HJWR5y3DGt+4RQ5aCssg1+RVXjct1XKc2J5sd/jGGD5GYo1fPwX4BHzd2JwQY8e7izM2vXzR1OCcfgYDCYxAH/17xbVFrss/wdadDMq+8n1Y1zSdiyezZw6Rr+0OI5vDSql/v8Em3kBFKQjnyixqX2E5oPp6Qemk62o9KZNiOcc1DCN+hW7/wQhUwMyVx2+Dghwg4d0YARaxgSmPLnpQL+sA3JjJ8vonV+4rznN+zw4LQbAEUjxiZjrtBLkMTjENi+sKdIAAk4QFYQOV+3RgJS60ua46dKuxSGbGq0L0Edy6WB0+0ib5rjteQKPmUO5ZBrcUmm4YgNHrl5yZ/Nu1XPvSLdEy/r57lHlZiXU6ZPtOBoYB8uZfDSQTN7DLGl0SeSDxfO1jOU
 VXbgXuVr
 lTpwyNUSW/bkjtIB3HYotV1nr7AMFLC6YUiM//ep3DUNSNKoW35fsHfzsfeIBp2zVsZcffG2qLxbnszH8LndXepfF2g5yJ72/JJka6dP4TtTpr8TcrZSnwWwKqJRjwHujEar9DuEpgtSQfvzgVRnw4OpC1YTIGD/iPyPEE5ZTE+m5WY5Sb/yCKhavPvdPRigpgMQ0OXu9SvXKpNe+rojFlOUxtvW0xSAxx0fY2EBI9iwLzs76gkPAIsiVaI+G4SrdKWQrE8mrlOWi3Y8OKqm49Ffz1dxW4ILN2Te9SbAXNr0NkeNYWHpqE5LrCu3npi0u9Ek/ZQAWRPov/Z1QHleLH5Aj1kg6z+M2jZQMiFiC3iMyTbiKDygE8a/9CNwf/JdiJln3N5tgmEeuhywQSLyQND7x/ekevHZtWMx0Q9t/GccCbt0M8ahyiTNWXQwCeV81IKv04YSEnEG8OwW3bEZonaN2SYcYBy9a8fHqCMCvHRbvCt42L4QWMjC35A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Harry,

Harry Yoo writes:
>A gentle ping to Kees to hear his thoughts on having a bit more
>coarse grained boot parameter e.g.) `slab_hardening=` to specify
>how much performance/memory is worth sacrificing for enhanced security.

For what it's worth, I'd still prefer to keep slab_buckets= and
kmalloc_partition= as they are. Each one maps onto one config option and
one cost that you can reason about on its own (about 1 MiB vs 18 MiB in
your numbers). If we want slab_hardening= as well, it seems easy enough
to add later on top, as a way to set the defaults for the individual
parameters. So I don't think it needs to block this.

I'd like to hear what Kees and Marco think too, though.

Thanks!

Chris

