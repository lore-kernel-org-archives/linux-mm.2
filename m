Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E740FC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4BF86B009B; Tue, 11 Aug 2026 09:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFBD26B00A2; Tue, 11 Aug 2026 09:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D17266B00A3; Tue, 11 Aug 2026 09:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B09916B009B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:29:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 40A9B40400
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:29:28 +0000 (UTC)
X-FDA: 85089070416.13.689FB0A
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6C36140006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:29:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ofWp8tOe;
	spf=pass (imf17.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786454966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9vBjygmcNS+aVa3FlHNEQWeRjGqbbUmRSnb3iurApo=;
	b=G2GraimYi5Pbl3/9OgaCi+/vfVJmIzs0OIl5B7PO2G8r60hVpXSMTTYXYCus60O75pk4e6
	sQO0Zjp+/H9U0ID/Htto8ulyi9rz9dvOLof6wqTSlPxPH+AEGaY26wVd4vXozlYw2KQjyF
	lUoaLXtoQ+bBIjyYTXiEkqPhOC0o0XQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ofWp8tOe;
	spf=pass (imf17.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786454966;
	b=XnDNsmuQy1TQdSTwAQeqjMhlYQRJ+X3+KQI7/tmjgoxkv7mC/b406IoGDooyEJI4JBxxYw
	RC0tVWnuA1YZoiWcswB45QZnHiWj50/Cxdx35kovgDegYKmgUEGKYxuPIp/7CBnYul5oEW
	TcDkVdaeVkVoG4RFhbj5mDRH+mis6UM=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4980fe6b3beso7996585e9.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786454965; x=1787059765; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J9vBjygmcNS+aVa3FlHNEQWeRjGqbbUmRSnb3iurApo=;
        b=ofWp8tOe5RDLgxtK/ZME7kiv++6IoOOiuRBGx6oCqbD5104TAo9XQSTgn5Mk2Gxrm7
         2sq//gLo3YCbaL35LUBW0NAk1EeeooZkDwpffQaThNc4CaNr/oZZMdxXdUJKRt+H0tzD
         Xu5Ajwqn8lwdY1Xrg4NSXE80G2q3HiMtKyh2KCJb0NupD25nQHuJJOBbw+W/2/hroEc5
         Xo7kB/61Mte4cRjo/SXr8bJ/9r8IUmVQstWmJm6JZi4cW1Cy+5mBBFl9LqZ24gB6gG2c
         snWZz66wb8dDmSKKS9s8ned6SsX3cKXvbKMGah0P/3iFJr0OmgbJAdqcfyghe/rKEZu3
         JkMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786454965; x=1787059765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J9vBjygmcNS+aVa3FlHNEQWeRjGqbbUmRSnb3iurApo=;
        b=SjFH7DmiL7HpQVc/ZOP9BqWZhclYPqVFL6wWjsMxpiLmPxJsYLwCWTpbcSjvgkSZWn
         op2ELMzVdeSjIwLy5lqO16G4qWQYLNYm6hBFkr62vUBy8zHSQkPl5sHfUvfQ2avP6UZp
         7SmA3Yrwp/A6QONU7xRLWMCL5vfPdQUk4OMtug8DpFcHso6pAosqywr0mSd5G3+dtvET
         FEYrP651GYxwyeb5PlMfqVzobK7TVce800Bhqln7blA519Ct4lDw3IEAENtD3UOt93bm
         bB3gqNSliSHxkbrh/D9id1Q7L0CUEpGGdAcYqE9ceU+LBDVj9TM1GQP+SCbvmfjktR0/
         4Pzw==
X-Forwarded-Encrypted: i=1; AHgh+RrSdOdHfvjTl502IxkouncZ+l7m8KIVxJAfrrU/Trcov+lMTYsrsdGSDiejmr2ozJGDuAKKMi6K/Q==@kvack.org
X-Gm-Message-State: AOJu0YzMAVjVWP+3BmwyGaNsRYkXhTfyXB88vn3bjZh6M7Lid/4MYEHf
	E4s1Hl8hYtoHGKXLE7dvQcEPiNlFNppRqmmabGLEirwL45HxkxWbdocQ
X-Gm-Gg: AR+sD13qP+w37dE6vkZaFIpPvYFdf2Xeh2MSTfrx8d80OyBzYpW9Kvp+iGET4msRvPl
	IJOuxE3mU4RV5n+HN9mpIcHi4XJrwhYs4VXBkklqIrxv13DNwdgdTeFkXVIWRQ3yFy7bd5iIXkX
	xrc2YL78e0oNf6QHopVJQoUMyNDIzxAX2Edh07z3p/7+BQqCY/mLX2+6F06lEK9AXtV2IJYw4mh
	duO/QsKnr9xVqXZaEdrsAtX7SYC0ggufXpxpGozSQcCHvnl9H1DCiuiCAsk4XsHdrnybVpSB5We
	xs+CwaYrXy3QutyiZWokRcgo1lKt3wrY7L5LvzbC3it4KdX3nwXiBTL6XgImiTJrviDwmSAf3nB
	Y6IsqbpgS5M7Uw10s5jRBzuMQy/RxFaweUb7UBi/Bo3cgBn95DSf8tkY/JZMzjYdszwowww1FfH
	/pNI+8JSs2/1KBt0d0qk35iJm1ncjLM99apI/tmiUiNheRysRzQMxRuBssv2mu+DGVx4CA7F9N0
	aTT
X-Received: by 2002:a05:600c:4894:b0:499:60e5:248a with SMTP id 5b1f17b1804b1-4997a63788amr1222975e9.4.1786454964817;
        Tue, 11 Aug 2026 06:29:24 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a6b2ea8sm4285953f8f.16.2026.08.11.06.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 06:29:24 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	kpsingh@kernel.org,
	matt@bobrowski.net,
	song@kernel.org,
	tasos.papagiannnis@gmail.com
Subject: Re: [PATCH bpf-next 0/5] bpf: Add user memory access kfuncs for mm_struct
Date: Tue, 11 Aug 2026 16:28:49 +0300
Message-ID: <20260811132849.98483-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811112154.94053-1-tasos.papagiannnis@gmail.com>
References: <20260811112154.94053-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m11nicehco8kqypybt94xtjywz7ahnzg
X-Rspamd-Queue-Id: 6C36140006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786454966-981831
X-HE-Meta: U2FsdGVkX184NcSfDdClUoS1ellPDsv4Tkx4lVG9KZUDbHIqn371+JbFTLk2HatrSn0QzwuVXeWfkp7SQA8DNxjSlvFDwEeo1mCdEV+snomf/TGYnK8eup+ukmGbkc1tOxzSAOud8HeuK8Di75eCFShoUm+XjdYIO1tr1EFgBoHNiY7vplG5O0mthavy3sbYZyusCktVSE2eyhDTrgHU1aWIjtD80aH1SHUy216eYXTF0cDKGfpj/3JB+5M4vZHvexkbXzGkKKHRzfdi2P/sGk9QqbDn8zmXg8tdScfVoVRbUH3K/miT2ePn9IX3FujcYgiYEOzKnz2MBHTPu1JB+ashowXydHb9TRWZY8nNrpErQUoiuUBD9CpVnwKJj88iTtdFUI5BC+SfyFnKVxL0Ffbid/Tcda+3h8/hWkLr1CGBQDZcIBK3q0cB7MsQzp94HZlYiHPQG7HnWndQFCGaF8lOZ0nX9RZb0nIb80emKDIYniccRPeWnFR9iWr8/COZs1LOVtvjAGo+nKcPXJsB7N97Pkb2IOPIOSSjM9M2GZccuOHpjI3r9Ptk/9PX4GuKKanNzhhBndHrYx1DwjaSSGXcmdXp/AFswKGPbDg/jCs+SFxQUMp2JG1sByk1FcxqQpMTxX761F38QF9m/T0ct2zxvvXKa0XZf5z5iGuT13QYjmmmb1YBrxJ6ja/MiXhK3fGVwlC5Et+RQM1IVaDfqiffVU8m9eNOBLCHRLE+jF4trNnuMHWHXZ+Y7Fj/JwfG8r3lSf4KrzW4JuICdB5fWXhytNHv+Y7O6L2FGjZdm9HyG9DCam7K2JtFsef9GcWlxwHfS64IRGQFSg5UP83Fb4l5QkciNRrPKlj4zg4q82dA9vqO0m6AAKHD6njvNky47pMecFNejCo9RGRvRY2TCZJz7lL7bT+KMPco94iaXUETv7W0KxK820J5/JaPfYZo4VbBTpJHdT0US5OGz5Q
 MXVO7GSh
 d4gXHaathhY5bJXE0n2BJRnxWLMWBLrNCMQeIbeJN9wJ6e+H/NznaHjfnqqRF3JVHGOR6tmPb1PclIPQLQ7FNAsJdHZzCNMcGKWrbX5GibAKacIghraCdhkVz3IW0XI2OioQn2g5YWnglwFt1urGQJY/IXbrv+OcV88xOgKjpSFg6BlfB3lShgxdCSpSspKbRCutoiqvzrTn5eGVcTDnXhc3ScqKsW3Ap/qxbk4MoNYhQokL4lommEKvgn3ihHvBZ2H6PPYKM+jgVAnQkqBHFnHNxCmJG0ll62oew8QSLlzBuQFkUXk3/RXl6Chuq0rqouh7Xn0mtDbL8580FLj40EFy+CTJBdks4/Au9r3BHhs0t9NRPMth4NjxxDvV0pz1ynogy2H2CJxSFdcLxujrS5BS8H3wMQ78USSCSzlJehsLcxlxDZg9qJ8raSHnXyKi2Ro3RHlmzxo0mkymOcGYDEwJlcRWQ1D8G3bHW02OnoilCoMkYt8g5VOsVo43mW+kl/79j9IDXYWlLDobOB3tUXa8ILG2eBdM7oQmB/f9jB++X8jo7cHVgjr5iUFfzEkI0dZxTZUNQc+Rf1JBcTJP97GT1JMp8FBiA3gyET6zvIT65mQT9lHcTxm3gF5gBwB0hbosUN8td8XZOffQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After looking at the output from
https://sashiko.dev/#/patchset/20260811112154.94053-1-tasos.papagiannnis%40gmail.com
and https://github.com/kernel-patches/bpf/pull/13211 I believe that fixing
those issues in this series would complicate things.

For this reason, please disregard this series. I will send another version
separately.

Thanks,
Anastasios

