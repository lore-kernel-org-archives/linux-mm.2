Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C464C606A330
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kxDEvFDZ
Received: by kanga.kvack.org (Postfix)
	id A5FEC6B05BA; Thu, 12 Nov 2026 00:46:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11096B05C1; Thu, 12 Nov 2026 00:46:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9008D6B05C2; Thu, 12 Nov 2026 00:46:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7537D6B05BA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:46:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9508140437
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:46:46 +0000 (UTC)
X-FDA: 85425382812.09.978EA7E
Received: from mail-pi2-f7.google.com (mail-pi2-f7.google.com [74.125.227.199])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0BD7740003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:46:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kxDEvFDZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.199 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794462405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+13rBtkeR+s+DndYboZRmZoW8VMp8Nay7Rh+6kbD7E4=;
	b=mSTPBUbDzdghIX9zW1w2d/yEQjP52i250uNgsJnJ4/vZEAswjpmICtScnVO49JcxW6EK15
	/0TZCV9J8EUpf+bzjPNLPPZs29W6L9uZBk2jIxLa04aVwjkwm/hB0T5SfwwcO0qQk5Qrnk
	tkBZ8q1K6nYrOBFVmUNKCM0AlFl+2DA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794462405;
	b=D/DimuR5uSeXR/kHTkpBTuJbb6f6fBg0L8DVDP1GRVtmdywc+HOIo0OK1nKNAnkJv7gL33
	7XgLwWX/WI+/qnoTvcp6k/WLC9ThgeACRmjUUbu9cuyVLROjm8Br141jVpTH49/fbEevO9
	h7VVwWovA42Ckap5NBX4YiRjAmXOO2w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kxDEvFDZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.199 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-pi2-f7.google.com with SMTP id 41be03b00d2f7-cd66d7e32baso922375a12.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794462404; x=1795067204; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+13rBtkeR+s+DndYboZRmZoW8VMp8Nay7Rh+6kbD7E4=;
        b=kxDEvFDZp11uzwTmoPIKfBT9PxkxwqOniu/9wp9YD28eI2Up2F67r0GG0kHDFh2C81
         B3gc5iTQ/vUJO72mXGlg26UlWk7HVnSNqZfJjcvi1w9MUK868Y2Zym5CRhSar18Q0NZ4
         iPDNVLD9RSfBJc8dGrQyFWHoxhCDS+lIzAM+AoZbFA0Yxsm6sEM6j6BRlR2WuEBx385j
         A2SjDSm8qXBf/V7OMHC62nOQfsxV1XX1PyJA3v3/rxpPXL3RkGtvHXdh3KxnUoiEQkv8
         5CqDbn5MjoeK4iPkQ6UMmvp4F6mmypSKo3dawE2qExo4VtucsEnEeQZyuW4nxQSSvmCu
         RzHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794462404; x=1795067204;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+13rBtkeR+s+DndYboZRmZoW8VMp8Nay7Rh+6kbD7E4=;
        b=Lifo5+fmlx2jrsXok/lglnLYb2cO8v7XTyntHNYGc00tRaYq3YGGArTerEDhWHGKZW
         Ayfg6IFS3Tdam5s1c82Io8iVsyJcIa5t+E1dUzWeI2uyLI0Dr2ooYn3FJQ6vaj2z7B8/
         oQ2u73wt9T4SOmQh92ZUMSNsEkDgjN3n/JFLtKS7naeBRI0ZzNfL+eQKPtFWWjnWH/6h
         B2gXDvqhABn7/dOFWOqeXcADQQno/704lmUQq3ER1+RJrFefGmYw80VKQUVGBWo3pq27
         DtJkH3Wfiehel20QqML6ul3HDtXkAR5B6s6ytR3BdptaYM/7++3DDoc687id65L6T3us
         SAbg==
X-Forwarded-Encrypted: i=1; AL+hErFxIi2b4EU9xqaNPVyyBHZt6kVoiHsgej5nIb1uBWAM/SKxr3d3fWof8LynKOigPfuu2y7k/ZmPnw==@kvack.org
X-Gm-Message-State: APuU4Z9rBa8WIKSlv7dSU8GM/knv3H2GTwfk+yNup8KQi6C6uaWcj524
	izIJXgZvIUmwEzwAwGeB8Zns8oKvmoff1dGNr+WzWwA+xqOXlodH6wol
X-Gm-Gg: AYBFou3k2EfSzSRT+PMgCDMfjNoPB63S7HdF35k4wH5T61Wp/Z52J6xi83jUaZ4cj2b
	vToVbUwaG4H+5jND4Qd77P1yrVqkUB4ZTwFL1d5LHBqO7ICTRlsmTfqH6MPJaBuyqo/KSEhCxVL
	ikczds1D+TWz4LNzn92FRwQ4ozBUfY/np3o+vX6KtDeyrvxwTBTa8ZQVJUDp276iiFov7vnUsMd
	QBdQYsl3NJq5i0uSnSwRPsvdcwYdeyOLeyTXlLAu2BpjRwuvqeX/FampLyVns/d89l7uXsF/I21
	TzGDRZyfEjLZMCgrqf0u0D5iAzH6Y8vE2o6nRzwi1JgtKVJuU7jFJcy6M5bJB/cusGMMxVQzo94
	43EbNntLtHH+EHNgSofU518lOMk2NizaFPOK+CCcPHi+zMPwBucs3HgqYrAC7z1yMZYdhCGlBNn
	ti/hyFERX390cZdfLl/ZLMNK891dpEWzTvD7cD2q6FZ0Doyg5eJxV5ltf7zDoamxL+QCWsglHnC
	wCf30dBNqJOyVVrdnwoybHaA35/6VckDoMBTaWYOys+xnpPji34gLqRuWb7FAr4uE7bS3hQIFSH
	M0B9SjG426RjGt1pbmcO2pGQcdxGSOhu+hhsaKaUjM6Zvk1WKL0+ohKmtcKe7zAQV9vecxeJr2G
	aJqf9hqfqK0LxKQqpkNgfdoj16g==
X-Received: by 2002:aa7:9a86:0:b0:8a0:4032:af85 with SMTP id d2e1a72fcca58-8bc16651ea2mr4128251b3a.0.1794462403606;
        Wed, 11 Nov 2026 21:46:43 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab8dccc7sm2776591b3a.52.2026.11.11.21.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 21:46:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH v0] Docs/mm/damon/design: document data attributes
 report infra design (beyond page table accessed-bit milestone 2)
From: Aveline Noir <jm5905938@gmail.com>
Date: Thu, 12 Nov 2026 16:45:39 +1100
Message-Id: <179446233975.762943.16115029371266375222.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, damon@lists.linux.dev, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Ravi Jonnalagadda <ravis.opensrc@gmail.com>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261111185412.145514-1-sj@kernel.org>
References: <179438255225.3134195.10613668244848761847.b4-reply@b4>
 <20261111185412.145514-1-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: cgmjt83bjtntk4ids4i1pgq16c38ikd5
X-Rspam-User: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0BD7740003
X-HE-Tag: 1794462404-402089
X-HE-Meta: U2FsdGVkX1+lPLrnLINsaEWgQS35dl1owewXsVgkEJpzRMylVDHKmI4ve+Ji0lMyq9u7jxik4+HJ4hELGLqkYc+ivzYFu6bubUEHLtgbR7Nu+WPzycjNRoSwp0kaSOgSBi13bUYCjeJtX6lCvW9pmPrfN65ALFX5puO9M2018TOj+ZEc79lKK4QjeHLenVIaxdh1vsBcpPSdxE38BIl5OtGYy2vWutwz80nZVh+gL7g1kmfhn8AEIceWI66dPAOcAws2QbYL5wKq7dM8ZADFgBPyVVAnQPrgl7f4PQdLfFQ6d1RrTGUu++S4Eg5wPJMbaYbVLXH1f95Hs6Fkkydsft++5Qz5Z6z2+xMNA1d0RFIiKjyjVzb4BhZJOBQV+4Tbv2Cwkd0rg/rbc2uCU2RwnlEhbmbaQuYqAsxydqXHVipktqNWSsuiDlNw1XjzMv44Kf7oAHACpHmQWau7QKFmb89mSm46TDRey3d9GguktngZ0Zp7upig9PGxCTa39Lyj+PIfDRfSeBujNCubfilH7lww7cPW3hWgDBrNVuYnf8HmKPgV15ABr2m1/Adj6JMWbMO/tzqSYn3Ypsd6o47A1azelwsd2B2aWdW6pkBMmAUAz2jMtR4eMgr3ntls3vf1RG7B3OGhF+EJZv/NOzXWhPOX4/mdbO6VPxC1gDFVoLXTi8jZ4wodLovzoIgSxbmJn+lpblzJKRpjUzQgFxqvNTcKUa4V+rsLNpyYiYvccowqHuMtRcIedRqAEtFFGmetXbah5XlF8Ej7WToXSVwvjp66xlDi3z26HL9GUeA7BsU2+bBhkA3wnygmFFzmRatI7QYMbuJkJmcA7bRBH1SphvIGiaxu3JomopoClY8ViQfF1Fx2b4ZoyvBWjeyLeUykdV68shFcN52UrJNtam/zx1Xcmrympu/Q2CpO0qTwi823AouM7eB87ut075gOhoCyD7d4zOtpGh3LceqlUFK
 show8vvr
 hUiRvGXeTXXqkZvRKqGEZOh7oszjaslGgGEKLF5X/3pLtdH+alNMpS5z5uoeFh3zIFDKBAoPsSX+HfvzvCAYZv7Y7aW3S0p6xB1EaY0n12IZm5l4uoM8iyYEWvjGPTBnSiWzH5gGtYQcj07drdZfZg01vGQtOQHIxIAWFcoKSI6mXiQ9k9eBxbwT1gvpkcsYdcxxRr5DxnZS8yoAuHntr1jpEh2BQV3owihl8bAwU015oLUwthFduT53RNpt/VY4tHgzQzLuQZQYa9OzSfiWMLnwpeWs5fSbz/rySEkXL/o0ousaYPc/bvPvW0Il4i/9c/svTUNg6sO72RK//i+jBTMcZxXRdn5P4BpHLGuIjaeJQX4yjL1dDNLBDExO2QGkeg0+UB4LlMn4S64a0bRFN41kfb6YO8OWwHKhQLtA4kGgfS7kUDZrLzcRu9/l8+cYYH3p3Gk8gjrRgwe8fIOFfmBeyeT2x2efIT1567X2rBIG02nboMY8RNZmafOsZPvcAD9jc9iKNEhXLKwA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Wed, 11 Nov 2026 10:54:11 -0800 SJ Park wrote:

> In a real implementation that is aligned with the design,
> the probe will hit if a report associated with the sampling byte exists.

Ah, I missed that.  Thanks for clarifying.

Thanks,
Aveline Noir

