Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE3D4606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 00:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=lFm7BNPm
Received: by kanga.kvack.org (Postfix)
	id E128D6B05B2; Fri, 27 Nov 2026 19:57:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA7C6B05B3; Fri, 27 Nov 2026 19:57:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9FD6B05B4; Fri, 27 Nov 2026 19:57:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5FBD6B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:57:17 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE0E0801E3
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 00:57:15 +0000 (UTC)
X-FDA: 85482714030.23.9B002D1
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id E7A80A000B
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 00:57:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=lFm7BNPm;
	spf=pass (imf25.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.180 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795827434;
	b=RZNOd6GYc1CO52TeymTxUdzP1kkV7H2MYc3weDaEEq9a84LIdI0w2obGG+7UMMJ8Ux/KQn
	KGZNPWlIz7GoSAQFL+uYOqoekTz4Pg9gOCb8RDGqvS4CJf0uatLs7LKsInj/xPp823ZsOR
	nJDZc+FfuiA6QV2cZXU1Ay0NdlMEhuQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795827434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wlqqG4ragrnBG3kIbCybUs0/KOwqWAzi+ZO0z7g/NRY=;
	b=K5aD6Ncu/Wl4sjEZSC6RvoAYt+KvHiu0kpJC1yL5xh+t7i63nuTb9KGy3AD+qlAxPR1vOl
	y5GIsr/AEih93lqy96kVQHaAA5dLOl3TbpFuSZwWBAJQEh86vMTHwR/AWBchjodkTpGX8F
	F+2/Wojelh/iifHzlV595gI4x/TDIxc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=lFm7BNPm;
	spf=pass (imf25.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.180 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8b32daac9d7so47609267b3.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 16:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795827433; x=1796432233; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wlqqG4ragrnBG3kIbCybUs0/KOwqWAzi+ZO0z7g/NRY=;
        b=lFm7BNPmAyhn6KRgKopNFQ/0zUhKDFo2+dTQ8gekbRCJXgTmMzuAQE83UWrbzC5qiK
         Uljn5d2jvA4f6O66axdBH+n8R21NctN+izQ6c20P3cJQWrP6+iMfhkzYgFXOjhF6n6ve
         Ke/fita2tKX7wEpMlDFXE8Ko1bAuyAfiAmYHQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795827433; x=1796432233;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wlqqG4ragrnBG3kIbCybUs0/KOwqWAzi+ZO0z7g/NRY=;
        b=aeKpF21jKBoEskA1CM/5BOfVUheNdezK/YgW1NPAaB3/+PnycAL8Yf+ykJHMbU+zGa
         RNMBMVEMClZm0BWsixKUhU+pOugFYzfre0wgQ3/IGi/woUjIWmEirhPN6PoLij3HEwnF
         ykKM4WRS1fNC2mb9onODvF/JF1UvG4Bb59g4+SyGqfFjC7CYNacKZ0NLDSt8cv4FXDkV
         OTrIlBPfvkASsIvwOI+8WeXtp0LPek2o5NGGn7rKHQ71R1kc738APeA8fDrUAINjgFFb
         LbNZ1utQr0t3hn7Wo+URuBp+RrwVAU3iUiGsH2jb1oTweLb1xN9UIA+84OR5eSY2W4iw
         f7eQ==
X-Forwarded-Encrypted: i=1; AL+hErE07l/tf/CA7jA3VY8xlfh1T3L1Tjjoc0a6KLUHjfvOZN7FQSsfJaC09snDmaAOCROr2+EuujG7ig==@kvack.org
X-Gm-Message-State: APuU4Z8T7N58cr/tbDAVDoNsgAc3yeHPVVrLKkCvHcdbDBYprtxrdSus
	ZsRjUUp0+IU8VE5adFHiV1QU+PauQrOgoARIOK5XyVBYzCxxVGi7m61ppBqVBv5zZSo=
X-Gm-Gg: AZFdTZdhkcYycyw8kQ1H2P4JwRNZ/hy3znMhNEUxCTJI6XmOHOc636TeBhmT7JtQdQQ
	iae5n2Oh6IyFt04x3H8BngwRaDFNhm2Bas/Svwt27GsZfWzTyegTXFb6HnIn4uFD9IwmLadW9Fo
	Xbld6bdCHvuaR7Ib+KgaUic1XOHgIXP+/+BNLaKU1boGvaYIR0dMHvlFsSTMmLkZr4B7JvcJ8Jl
	ou3S1a5DY+HxLRuTyIOzp3M1y5p6BwKTVsUX1UV+V0zAEEDUEhsFTIQvKipNhsg/jz5p6PHa2Fq
	RCjZTWirMTKgX21y8kYOGpNkKdBTtJEPdsBuaZyGcNb8+DF205r3vQWplhsNrdzkgqvPMz6YsBD
	dIcZTwRxJq5pzdcrBaB8GX4gxFGQUzAhx6BcXGObBrvuJ6SsFBLbuSydVfEb/c8hAadhACyxK/g
	V4hMmDkT7IXpOVlpT0FnHQEM+TIInVfkWDxpvHk8FfjzcAMKpyR7jNYTqAFT/Bk4vBUjnUDNs24
	D57CdC3wzL5lfbfSFgKhj57VKPnx7/zfVQiq8tH6SrT1QJE8Pf4t0WReJJwRtLdTaUNG3cqhHYl
	VFi//f+55jnbqCbbjVt6NTEvN54Rfs31A9utn8UZ8ucvNj7ostYudMP5tQsvsgvUX8FALwAA+6m
	Jo1zgQWr+XakydP67c4XNZoEHVQAG4AiyPtYW3xwNwSWR9u+P2MLQEhn2vgxyL7qN5DUSh+X8mt
	yvu1Ninwu6rXi6WWo3juAdDyyAo8GUTqaBrAw+NGz6Wz9mB/z40y3qe21GaxOHzHCjrZK4a0szp
	syWhNiUXNIsgVvhEpm8aCA=
X-Received: by 2002:a05:690c:c1b:b0:87e:645c:182b with SMTP id 00721157ae682-8b5204dda89mr106486127b3.26.1795827432517;
        Fri, 27 Nov 2026 16:57:12 -0800 (PST)
Received: from [172.20.0.2] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b52028d628sm99080227b3.8.2026.11.27.16.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 16:57:11 -0800 (PST)
Date: Fri, 27 Nov 2026 16:57:10 -0800
From: Chris Down <chris@chrisdown.name>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Greg Thelen <gthelen@google.com>,
	Greg KH <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>,
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock
	against filesystem freeze
In-Reply-To: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
References: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
Message-ID: <awom5tLa6tNWPZYK@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E7A80A000B
X-Stat-Signature: 3ki384mis7mftchat63mp938qu95ft8k
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795827433-118579
X-HE-Meta: U2FsdGVkX19dflRwPi7DALO3jUFO0+39UmDHBxA8pCn6dOmTDxBl5dMTuMOfJESqdWLj6kVX+7pWbp7nZplIKwlI33UjlFFG+8HbGeEkkKTJd0yGuEzkwkXlElaV9hBhz0H1rzeBWNmk0jCuoW1mJ5oN4y0mSjZOZEYEV0HpkQRCudr3V8A1je3W5t3BQ2VTNwct0yKNr/6wYCfVTbBW/EdwYNgb4GlLB3ihrYFT8XWULHfZ6jnQv+9DXdYwiS5ms5ZVGnChNXcLdgpp/9GGHhu73um9HueuX4+wkTq+FFnYTq4uumtLwNs71Q8r26frW+MHkCffzGI183NExlnXuRzIpIQwHSvit/f7AEEqoN4yWONItlkFDcdKrIdQuGEu7j15D8LldRRULkzhXVmt0f9oWTb/11fAq/2mRDBTN5Rg4I9QVFPRlJT1on0647KPQMoFLwwm6No5nKKapy9nZhV3dqiD9ye1dtBzaV6peIyCqqGl6UTTWILSnjLJYdOTbm6sikPAQgKiU3F3QD+6/2oKBzrmjHNVoQCMhNGElFao/TkgbUneby6AuuDD+2RQ13sj+LpriyOkbqnMdPBO17JbAxR4ASQ9goa2MzS6m2PS21XulcVITHPMPapDCN4izvWOp+h7381NYh1DKEUQffN20sVX6Sxlw58p0Wp4RlwfJQhGjeqcB+kh3zyF87KnRFh58Y7PUFHNL+Ecrp8zmoZv3ae27qqUW3NkqQYuC4DBQb9ugl8qadO66swPa+jJ3cKtnTbUdlCy36p/xrHoau04ziM3MZCWcgLhIXZ+bPshFh39HWmyY+JPeWR62cbGSAFfC4T5iOEIOyKihM4IukM5I/s1Tg+eerqR2DC0x0N6sRBJMDzr6A3dyKjOtJVq3UxFkSwH3ajtrYyt8kh8mUdV99PU3q0sFWCUZ5Aiv4pkfP8v9bVpJohwuQBmdDrkw6zkUSkY2+18DVIwXsJ
 XkWW5rjG
 2jbfvGg+g6SgcqbgCTkxMuSV6Sba6mPYEbdunfe9Q+2AiizH9XdXEKgAPuJkwxNGk/qLv4NHy2Y3Vbx4da05W8bx4ENJIAmRqJi9tXwlBh6KiAZTyspljL4w2Kv3JmDmyqSjuv72XOxlEjZ3kvns1ijiDMZSyVBk3GG0LduIrftXXhZRfsDGcS15HZ1kYG7WSqqw+3wtfClXlWEcCywuwvkvWmG8AucbK3ou76PMWy49POZmd1c0uCJZuiNHijnakefeZMifiNTlMixG8ltwUsBJ0Y6twO6TZ75oyM0SDomxKvTELh6g2yfNNvhXBM6gBIyV+180TM/PUQOKhZZWNePNLKv6OAi290vr/6zoHHbiuna0LOnCBPfo6rS5VtEKMgG8I7fHX3lyH6P26iMSJeDgCtKslaJHlz+eO+zEeXOs0GkuVu3jreXJZistJI+j38dVDFtCN/uNL2SI8SP2p9SBIy/xeun/iFKXAuPehEZ8U+a+/S1wXuLLCWG3UdCKCCDDRReCyjXaYF4di018gwuv+/1fUMtgWKoM9meKdpAzJIr8hrDI73Gj42RLtSITopC/f1QXC/LG9owCdBZ5Ye9AnS7MiPfJJIeqXKdVVJlPS2Kz4sNvU1TgTCmZ+qiq7tOsrnUm93s58wNEUDPrHp4V6o7IN0yKKOgeeDabiINEyidsjwk9yD4myz3xHMNK1xIH4D6R/V3X1QrJ0ZDZUUtvUeKh7WLIBPE+Yxfdn1NNJXMfiNnpzDb31lAjRXJCwzc/5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Tejun,

Thanks, I've reproduced the deadlock against fsfreeze and have verified
that this patch fixes it.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Chris

