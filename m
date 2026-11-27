Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40F5F606A321
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 02:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oBAyaSqI
Received: by kanga.kvack.org (Postfix)
	id C80A66B05B0; Thu, 26 Nov 2026 21:30:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C32A96B05B1; Thu, 26 Nov 2026 21:30:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6DF96B05B2; Thu, 26 Nov 2026 21:30:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98DB66B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:30:04 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31F29C01B6
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:30:04 +0000 (UTC)
X-FDA: 85479319128.20.25CEC79
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5A404100008
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:30:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oBAyaSqI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795746602;
	b=PZ8UchU3IasUXzB7fdzBrXuzFiqb719KfWptiDwtexxjgAIX4T7FZpLgbWbzVU1U6JIswV
	sXysCdwMYqUfH8xuGVJuh3UJ5bLs9Kvini7hw0bv94zClF/t/nc3zxPlKm8kcodjuAodXf
	6L6VHbLGO7sMFMAI7O37OyutF1eVuXk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795746602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJr25Vhq4P76gjl7pK0JdCfn3jlkiPef7UPUuvz/uYI=;
	b=MDgQGaUiLPS2zlZ7Hb9hrSdB/gQVRjaY9qe6K+TGZr5uEW74P5DsShpzqQbLzUl5k5l+e2
	2x0yqZZJVZbuQUB5b5/+aM4orc91fENNWFkbfGuZts2okH3MlJwJyIxbgn3OshpyM4GhEg
	gKkSi1bTbQSGqmu6kF0ffOAssoVdHYs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oBAyaSqI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1a2761c69fbso10596877c88.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795746601; x=1796351401; darn=kvack.org;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YJr25Vhq4P76gjl7pK0JdCfn3jlkiPef7UPUuvz/uYI=;
        b=oBAyaSqIPUst++POU9Obv3rVlni+pJ1I583CnEG3O/nN6WTxh4ibFO6itsvJKPip3g
         xOmQpceIJogfKEUwD7I4z/oXaa49SpwISBoaHbAfyC92L8+O5jj083j6LUwdoQogjokD
         +fMXxwmcUSvrbKJaYVBKnVEvvSl9KFFkRrNp1YUy6nfXhcYu8mm2XJ7G2R5qkOx7Fm6l
         8YYLGbLjukgmtWQiUVEQkGye9MmC2xyRt688DFvOQsmKYV5YTiattnmYf/gNLY3933Yl
         vLTgdtn/+3phQSrEt8S/DR/9RfN2IqtVBONGxIuCyXjUcweilbU42hz+QwahEf0eLpQG
         yQWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795746601; x=1796351401;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YJr25Vhq4P76gjl7pK0JdCfn3jlkiPef7UPUuvz/uYI=;
        b=U0rroZUf5dmkka/mK6AjPJxAMw0V+gc5Vi3WcZ9ilaVZZj3REz3yqatgIQHmcozVX1
         m6l+l/StI/QW/n09mj6q2kO9+kRTGzQilcHghu0ES5zyLQlg3o0TwvYm+Xc1y+iDQhFD
         Y1SqVvJ/vEniNM+x7lF3YsP2gV+rx6GMoa+4RBjSYCDDu2hccaUpj5IkctVAD9VW96FV
         EdmtqnN/vH+mXJElEzXw5185PbC6jgMwd95D3CNoZRqfprQrAqqlG/zmn3pk8nLjAbJZ
         pTy0Bny9lSGxbY+Lq5hC52fDOg5cNW04rKeZ6xVPZh2cIA/X0MOCtbhz1+AwGGD72N/e
         6Krg==
X-Forwarded-Encrypted: i=1; AL+hErF9A76zBRWQ9I2oCklRcO0x3F+OT5BJgWNjlNxsHt8G36D0MHmJdu9faQaqac9m7edGAAJCcDk1jw==@kvack.org
X-Gm-Message-State: APuU4Z9MB6sSxFq/rxB4nPaJpYq/cNzP0Am5/G0mim23dRt3j8Bdx4S5
	HIfr/4p+liXivo5CFjxXK8MXCJ1ls8IECpN8gDaMyIYsUayKr/IAbqRC
X-Gm-Gg: AZFdTZes0owfTzZzGxpoEP/f7IGZHnhgk4l+kO3MPQjErtV78d4CpZZCtrM6D+MUPb/
	s6MDgnkUzMQ1rfDj+8UNeS5jJma/e9DjhDxraKEr7mhOAF73XR2Om6esFxt3kyvS3tWvHa2iBL4
	cByLZI6ze4ViAqDNJnm4Z/mHElJL6Hu+oL/zBUzXD1LSYTwO7iII52p6ErPXETPY/zMXmO5cyqF
	5ULj7fxVBM6OX+YjVKj539UR1ZhXbwH9QxztfhqmNi3mwtekFpNEcOm5M3/SovFhnamLmvxphti
	Vy44fbMtb/ltx7x+D0R+DPt+7vay88tZhwMLrNeG5JetZzTPjoIcss0oovUZl34O8xcHJ0fmbXG
	OegmB7JNH6mdbBt2XMiuDHJvM0D/hPGk3p6QdY9xIAMIMtwZJmefcxIm5CT/XkT/w0bp5Y9Dv3o
	t7s8yA1WfXK6KyUgGjkM6Pw/i0cgoSUPx9XT/3JByl5k8WV0h8w6bvq99S0WXPdqzkyilw9JZdq
	cJyuJIzCCnbRLzSbt97mwQn+3+d2LOTyURRWKAm3D4/RhURXCZpnUIEIhpvRlu/rf51/6Tcml/k
	+6lPuiZPUuNpLydGwD32iIQNbGBiGsHs+qmHWHTUr0zcic+e19zQWZ7vuZPK/ebmuj7mfUFs2wk
	BsjymRw==
X-Received: by 2002:a05:701b:2087:20b0:1b4:fa58:9d8 with SMTP id a92af1059eb24-1b5568e76a5mr22857082c88.20.1795746600887;
        Thu, 26 Nov 2026 18:30:00 -0800 (PST)
Received: from HFGF46V04Q.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556829d31sm86938260c88.9.2026.11.26.18.29.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 18:30:00 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/4] mm/damon/sysfs: refactor state input matching
Date: Fri, 27 Nov 2026 10:29:21 +0800
Message-ID: <20261127022945.8243-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261126210619.97634-1-sj@kernel.org>
References: <20261126210619.97634-1-sj@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: epm6knooqufrtiqk9yupemx71bsq3b9p
X-Rspamd-Queue-Id: 5A404100008
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795746602-51973
X-HE-Meta: U2FsdGVkX1+SplBTqXPC4gN0wRCcypcIJ2gWYyI+EW9qyWV3gNCncC2THNET1XUoBoKTnDFLF5ojDXioTjjGqedZNnfLnX/wzIn21Aulzsa7wIsVUc1cF4X3oATeZT59S+9MXfRXCWZgs4lhm5SW7v8AFyUtMYb4VqdcSu45EjzEyOrzyML7b2I4VsV7MdkiXK7DoLwDAeQT36X2Ssg+eYKgdbgjfBnfj+e70RrRgRX35eFnpI0JpGWE7IqlZTVmXoajCmNnuglZIBSRNiojIhquF434YjTqgZmsMIu3qQH2WUFHG8X+Zo8Zw0ZlJPjMmx84wQbK8f/p5aNj5+rbgYI6JyxL3n/c2btzvGQICoUvZPWF5E3seHNzXVGyiEtaVktErk7FAFISjLK3s7LWXMZjMQiIvitbqMR4I5FZzZkeb7KBq1FyY+oczf/cX30PcOTNQzSB9+53ZXc6VQ3ilKO+xinPD5ymobnvDqLh6n+mYZZGyMXC1FqC44yy4waIxnp6tWViZrL13RMXI/tSZJ9ce3Fg2LIw9gzbve6tx5oYm5pQIfBQj8lMsrQ0vRh2Tx7NqD0++YpLKpGXkuEnepFkwRSqZxAW7qlrDTr/cZ6/r7/15Ywe/t7fqh+2ECw7xdo81kh4cOGFw6Gldkc/cUePcY1BJP/aqxbMlcyZtMTb7pVx2/NVcrZHv3H8ivUj/GB+ip7ZFnhemhBc4URW8wQq2uHPUCG1LrvyOs7eFBZjwuifVPkqiXTZbA/h7IYAseeDFSgIXTgCKo+Fpe5ljVJMfytf9dcyNLr3gdw/kO+R4oo+47kntT2IHaLsrIq+QMKdsC/HF/ABArO9b9sUnd4KwPT7xOhcQhBEzpa8iaCNecmhb8VtvFZ6vnOgrtUU8g/90KK877IIN6Xn43TskuRyVqiCsMHyL+FgaSD4/h9Cr/ANQNlfgMqEB9y9uIwY+5nUGzrD989FALzMRrY
 YmXkQfYd
 8gXU61zgjosVeU0tUOxRo+4saWF9GBfE0Dq2+5Zrwti3yjwccaM4fXDJMRVq69ex66Cqkx/f9gX60uT1RY9vo+gs+n1UNu9EU8+KLF3eTYYVTFnTYJct/1jKR6dn+f2IVmoMc/K3iT/WCjiHYl1MKGlpQXYnsLE6iizLoHr+0Tj250DeErw8kExmjLi8NR9CD5yhpZng/ip64eNwWCjueLkCKuHhEANjFDNJh7SYTsTWJQ+5jjbIArOccqv6nuqVKOb40Nm7TiuY8sbvghnb73P1JU3hhc3rfjaB5W8ydRnDEgZXeykmWNThp6UW/W1M+JNBEWyJYEM8cEZ01MNa4FlI+dPbT7zHx4BAE1l2YKCrRUtfDZZ0PAiBqaQglnUk7qYriHxTmIZ+X4Xe86gp+A84fRTAVgoM5F5GnwHwa9xu3cSG8RR+lEMS2CwiHYHnqI2P7rRc2Qn6dzPe4aNRYB1/mwT9Buo8WnmHzCJa0nie93Y8tuiuZ8vVmif2EJxa9UU35U95RhcgJctLbervCr9evELstXKHcW3ejJ5H88V2SZ8CBNNf7REOLIIF+eS5BiODJdxdY+841Mu92ZPsTGqjjYkbxNg2Lt6GKJNKQfpcq64XVyieHr4D1F+/+q2bkdaqSBInt9wGIqIhLHdut1QW6Pq6Da4qCmdmbi+JE6alPvApZxdEUxtS54CAc0b5qZcnVeHgfCSHA07F4zg7g4WZgdSqSFilTTuwD5b+95VLGaLw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

> It is easy to mistakenly make the order broken.

This makes sense. The explicit command/name mappings preserve the existing
commands and state read/write behavior while removing the ordering
dependency. LGTM.

For the series:
Reviewed-by: Lian Wang <lianux.mm@gmail.com>

Thanks,
Lian

