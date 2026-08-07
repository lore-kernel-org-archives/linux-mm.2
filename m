Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1CEEC5AC67
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 03:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8220E6B0088; Thu,  6 Aug 2026 23:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9C46B008A; Thu,  6 Aug 2026 23:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719886B0092; Thu,  6 Aug 2026 23:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4803D6B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 23:14:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D580A1DC8
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:14:00 +0000 (UTC)
X-FDA: 85073004240.11.F87B85E
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6EA161C000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:13:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XDkFxLik;
	spf=pass (imf20.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786072438;
	b=N3GxOmhUVtsGCzWO9w4WgYiPWAUtlnU/nmrRR4/WWyMUzEfzWOMzJW3CtMmeOiWFF/H1nm
	ZUAxpqZ2KjA85D2wz/1DgjVTD4Mq9IM804v0+7Psq8H4RkYu/rQPbb5RF+OsynEvUjYhqL
	yjCwQsLJ5ptmftAEWOIMgjUaedQxiF8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XDkFxLik;
	spf=pass (imf20.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786072438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMuxP0+J4OeLHPbWlDZiX97eHli3LW/AfUXJzlBn1ys=;
	b=UMk1V58YA1zWvmlZLTj77y1bmr4tXMJr8DIXfwfFyJ41uuJj3NJWl1modg6Wro/B7JeSbi
	FBTC5ZjNzHGMnmI5C433SidB2FrkB/MOWg/3Xnf9pZA5DyykUZGk6OEqXKchyucmB53axS
	g8OgFBcfbO3YW3Xdy4nsq8g8lhE64J0=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2d0407aedd6so32720895ad.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 20:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786072437; x=1786677237; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rMuxP0+J4OeLHPbWlDZiX97eHli3LW/AfUXJzlBn1ys=;
        b=XDkFxLikC0u/Pi7a8aUtMNDPjf5tXzk1kwFwMx1N9ow/jwRslUrqx/ebkQDrPNxtrw
         glEl1lBzQHdX56+VddWHlU43/syKR5QIIFf9537TCFRmdC02kNQVsS01G59huiLLpMCg
         XZPJ+delV9SNuPxkCYcA7AFakEeAz+ORuLdKCrnrg3QEN7C7gFwrmJt7qP6DvNzkn77i
         ObRpmPXTOkr7Ez9758Bs39figMGHmeW9cFl83y220DvAlieJkH02I3wPtbIzfZxFsp+J
         WN8HZ0zsYGMoNxbTD2Xjk/vPiPFo36XkmMeAACXMrkn9HlcTA9x+fCa4bbX9JeCI0rDX
         PVHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786072437; x=1786677237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rMuxP0+J4OeLHPbWlDZiX97eHli3LW/AfUXJzlBn1ys=;
        b=RIRzK2K9hw6TtxnlT652NURFAK6JQtW5IpaBsQgCkB/hbUJlHRbqocpyHKzJwkQ0Xw
         u07cgqOxTEOQBGbV8Ayv2o7GvextiAV7CFUtWLSm0inTm3BhXZD1aK7QSrZaVlENdrQ5
         EjNj3x/AfI69qhUxHebvMGJuqMTrbAe555ZWItAj+c/iKXwtcyEL7vQEswHqyglVjT1B
         uVetc+u8N4WHsQmMrSP/fA7oHtPg8JinnakU7ZLsU5/Ak4cZaFKQ6QrPi50/7/6XR2n1
         8ydqv6paygjeMh6FF7quRLJxaVabj4PD4/WcNN21q87cj/GJnynIpAhc8uXwo3IErTEG
         Nnfw==
X-Forwarded-Encrypted: i=1; AHgh+RpIcAZrCOqK6/87lkMOgkapWNoLD2i2objvHrP7jodGh5PtGDHpzuY/VaaN6mrW0esayO95wQDOuw==@kvack.org
X-Gm-Message-State: AOJu0Yx02qy3amrknviDujA6Ic9Y1Yt8FAUf3ne+oNjppWCfFU0M3KnM
	N55So4c2oDJqKZYMow0iKwUfAZognzirZed7N0cI3tkIgyuP0WBhrngI+YwZAA==
X-Gm-Gg: AR+sD12JMpv3+t3shbBrG7vmFNsSO/pcD8wZttF1qChE1s3DvBZEyT4+C5rmvnXQCRj
	1zZ8dP5L7qmifFUgw/XeJgbZIBn8NVLtUAaHOGdb4r7An2fUIWEjU3ZN60Veqdp1z/mUf9VV43Y
	5Zi5xj2ShLn1sv3IesoMsl4NL06cEScHizTmxPEnjSjVB0oB8R0QKZB3+3amKG4mFqsQY2AfQyU
	26IxG19t23puN/Wtxv+DxGRY14rz3EF5f9XWsFxX9CxcqwC5R31dSobMoeHuyD95BWTnhAtpT4G
	gIP8YECk/lcN2siZRMwkUkZipS0VuN6zWas0mbxDiRBeA+zoXXh6QBxe343lxtcEaWjzozFkIxQ
	7jVX92ktCDqJhO3tKb0PYEx9oK6lSiJGRg6rtg+HtNsBDYGstlMsoeFBIHIgALjAZf0akbJoIMF
	9cVprH49lwQ7IaTKtX3PF81uOoZqcmmeq/iWQwyP84HyINjVQmej3CSti9L1HpKBWt6eCTOMjET
	/16ujlOVmgPo9mos0wgf/6OzPqLvQ==
X-Received: by 2002:a17:90a:d644:b0:38e:2860:253f with SMTP id 98e67ed59e1d1-3903c582511mr20343466a91.12.1786072437209;
        Thu, 06 Aug 2026 20:13:57 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-390b13b0c74sm357248a91.0.2026.08.06.20.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 20:13:56 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/3] mm: trace: decode architecture-specific VMA flags
Date: Fri,  7 Aug 2026 11:13:49 +0800
Message-Id: <20260807031349.3119855-1-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260723092905.761037-1-zhaomeijing100@gmail.com>
References: <20260723092905.761037-1-zhaomeijing100@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6EA161C000C
X-Stat-Signature: h1r43hp8asis3od5e48z7t3wr9uwsdzp
X-Rspam-User: 
X-HE-Tag: 1786072438-577989
X-HE-Meta: U2FsdGVkX1/PHv1YQ2oYwjGDnnARuww8RiIAGBw1X6jT5Y0PGhBmXG2791TGo6QMjp1lQsiVUDb2cv7LRv84XGe5jLiQMTNylsRQ8NTKCINjYBDbXtWA8ESk5IVuN13f3A2qd+VMlKZzPwq9LwbnuVOhjsxy0XW1laT/thj0HixJ0F0lsI/Hn8JSo9Y6lE9P7hXqQmcI5ElntlDD+WbCs0xKzAl+dFrTweVQpS31YsUmsWzfU8EmBkIuSsuVXCEe3m0RYndV/L3Cb/ZoqmBZiYKItAV4mKRL6qMiTkFsr0FV9ShyDSZSy2ArDQNRxkjpYy5UWZFea9HemwIcQ7y4JDSJMgZr3R4/5UfvhxJFE/NPaQLSC3Ml83asUTdwBlmeZBcwPAoD4sblLiokyEjzylNEonuhFAUYI0Tytk6mufXVvp4GA+zB0wzyNET71GWirE13E6XWLtWZMO84g75bG4qOlBLwjin1Z/fPWIhoBpxIiGtqVHR6Oesv8X4vRH+M2oRDxJ6r0AKSIsZL85779NJQ96vvuYb9fKtgVofp+6+1ZCuEFpHXlHOjCcWacSbfQ9sAiILaoao6PX3KxmRH75aZTx2uVTF9B517aHOd1Q5wByA8raJtfDj5U6heGR9DgrHycepcov0mOF3W8OylWX68IIscE7OpliJQTZTLumfUeqBNyG8IpbtpGwGbtX+Os8bfonKuuf8oc+VL2G3xtPRcdWHHIJhTILDHT8cFNJukondIupEh478tBjX+VJj87IdWnUNF46euestDUWZHN67VowF8RnTAZ9ORKKFRNrlo11IklHELyvGa5WUdyU2uRxIUl+/of+Is3UcMs5zav6Gjk84vSII9v+D7ldu961bCjm44PmvsPIDsI6/QxWx6vj2foe675a9nbzDjJYzD93pDY2oNNF+9VkvKBkO88oOaJYLcQxImfDzm9+XVpYjsy63m0+tWZNlrBNVCqRP
 T+hKcKSk
 0zr3Nq3cIq69rQBrqA/HVUjB4YoSffwhe2Nl2byAv5OU1zJXTBlgvK1BZ76rXTD81omShix5WNhABnHfWFIAQ3gSDKZjVitXpWI06Ib8KcghT6Qx+cK5itE/fp/cWPwfOeu2ATJRHpax5hWgicIwsVfsNNKiaCfY9FYIDtfzmdZf+RyB/ec2HavOyMiTl6is/Ggoewr+V24P/FSsw/Jmh7TkovherXJq83lvCQQVKRMPh4HeI9VxHKs6jRznhwCUHRAfE8baF/sp7HFgNyBNKWwISFTjeHep3Lxmome2AfFdyl9FAW/MXkUPx7NWcre6r0iB3Di3oWya2yfYVpHO4w9Yqvo6jIyO4Yapw26tR4LGkByUumY+KMfF1ON1gP3XNRVsXZqKSRTE3VINbfJZmDdTN/3agPSSt1/v1L/m4R2qFJLYFM/6wJj+19tLzPYlg4ez260tHYjcp3NI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

A gentle ping on this patch series. It has been about two weeks since
it was posted, and I have not received any feedback yet.

Would you have a chance to take a look? Please let me know if I should
rebase or resend the series.

For reference, the original thread is available here:
https://lore.kernel.org/linux-mm/20260723092905.761037-1-zhaomeijing100@gmail.com/

Thanks,
Meijing Zhao

