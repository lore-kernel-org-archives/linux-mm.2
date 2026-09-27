Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3AEEC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 14:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1593C6B0088; Sun, 27 Sep 2026 10:53:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BB816B008A; Sun, 27 Sep 2026 10:53:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC4B6B008C; Sun, 27 Sep 2026 10:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C4F976B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 10:53:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41B83C0A57
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 14:53:58 +0000 (UTC)
X-FDA: 85259836956.10.54C2546
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7D489180002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 14:53:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M4DEyHX9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790520836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47QCiiWBjYaD7BMaolGfIqq4ppH5IxXyHRYQ4qkMx6Q=;
	b=BL7HNVX6F+oa59tl0FB4tgA/ROimHc88SJj2DxTlSnn2givHSJ59TjDOOhFAcdqmIizRB1
	hzX4Ujqv+eyCdZne+Q/T21v2KeqA1UEQpWruWhe9b1xxx4Glq9zrIV7naG55jRZatLdEyU
	uy2GbEIWwJtjhA6XC8cjffWBWqnTf+U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M4DEyHX9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790520836;
	b=XTxoNxotO4PQNAMKY4KY6u3z1x5yH5pPzZswoeOy14oM9NufNl7F/YIGF+geHTaXLeOnXp
	puEnZQu5WX+gIowyS0EX3d7YYYbLl88yb8HNPVrbsKptao3Q2S9Hea2X4ZZf8mxYVrriho
	sugviANfjNKHk7H8vnXAmn1V7oy3bcI=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ff9621c5dso7481155e9.0
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 07:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790520835; x=1791125635; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=47QCiiWBjYaD7BMaolGfIqq4ppH5IxXyHRYQ4qkMx6Q=;
        b=M4DEyHX9oDnO+jt7cfvyCpnOBYApok4tyKoBIJYHLbqbenjWBdb+drs1f1vzQYnGUD
         rne1hPXylCxQGOfQ9IFExjHfSZ6Hp7kSMW1ikF7ShtmX+O/DgNeEiUNrgpgDxF7CbpWZ
         Xy2zMNL459jVOLMbl4gZzqB8mKoJeI3YVuSPKgUq15eAf1mtwAF2zqPwCvZ39MwB+z0D
         0aKvOpYWXKzWDKrTnkrQXgVqsk7bJaUCSYkhK7+dXluRCgoQVAr+DCsCiQ7gLIzBX33V
         496Wt5wsz1lNKlJGr4EOjTLcdDu/XmUr0wWtesDRA6o5pOhBNNEAtfOogXn/w9ed9+se
         opwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790520835; x=1791125635;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=47QCiiWBjYaD7BMaolGfIqq4ppH5IxXyHRYQ4qkMx6Q=;
        b=y8+2kDCzzeDF3sqrdpMNebYyzQ+r7VYTCU4COuZKUA/dGwLQHrV/z8+cOtFBZk696s
         oAYZ4QeEgYwezogzk6tH++9HGZ2m9c2arKJCu57JXZ8KI4eGFIa/HfIYPZjJeW7s9Dnn
         6eRaRZMlRk4eWgxvTAlFlD5pPfDPun9GcwsT5YahlSxgPdUpLS1jUy/FXH3K4lUzOQUu
         qNVwhBY9mo9JpXBkDMxbBxCp4u9gNHDdSI/L5vn9jBUgpVbH9tPLRjIS74kidtdgtnBD
         T+KcvHsDGl5ll2m+JFYQUNufj3kbMx8kjAxWgiPke8XUcwB0tZX0eD2ilqB4mnrVjYUH
         3FSA==
X-Forwarded-Encrypted: i=1; AKwUvBwV0xDqmI/zb6iuWrbmsDIxtyzpVEmnahaAHZ7Q7n07Wk8SiF7lrrt36fwsZKobH0i2uE4xtKiQtw==@kvack.org
X-Gm-Message-State: AFuF++miS2FZm6tFfDYhtsgGJJraoQ4gxu9Mg0K2AyBPDSSHId2+Lt6c
	SZ/leNDvZVx6993D5mt/AjoA6ZYUpSumdk2Ba9kx7vUxrRWzBGNeaiUO
X-Gm-Gg: AYBFou1kkkVWMXbiek6TvGmM8VFANxXcviXMUhT/wEmUEckGy8YJytWIrvYmpsF4PPo
	ozb2pfuoYUhSa/F1a8PFtscpSLw94MUrH3gFbdwwL7leE6pSs1g6S3Q2/oyvHSuH6W5PEJ1C4K3
	1roDs2NMgwVl0XOi0kbQLo/eXDzgVByz70QpdjmzHKkncro+GYXYcmHElwOK51i6kYkEZTIdngV
	OxkcaPf8ubrk1CxPw9ztqNHFrdmETYgsQjwv9v5NfiKtRVp5UD5VsHCfPH+Cxnzu9EgNoD5rf8E
	mxVPB9UT0FGXn/xBXpIBGUy71oj3XD4k7XA4YkZuM/wqNP4eBLYieLEXI8p0ljIjbMKBEzrtT6X
	ZuxSQ4U6O7RTe6DUbcQY4vfdc6xJOJ8v6lZK+5zgxhX1kMaOsJfye6JNNrVmm0sTWFAbiNnnuY0
	QMaXRKYfrbfHFx95pCWF5lBEnT/+Mc3LSn1dheVzzfFRCGPvwrv1ph8OYnYQgCkJKzRSM7qQ==
X-Received: by 2002:a05:600c:1912:b0:49c:fc6e:8cb1 with SMTP id 5b1f17b1804b1-49fe66d811dmr186291185e9.21.1790520834817;
        Sun, 27 Sep 2026 07:53:54 -0700 (PDT)
Received: from gmail.com ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0017656cesm60949975e9.3.2026.09.27.07.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 07:53:54 -0700 (PDT)
Date: Sun, 27 Sep 2026 16:53:51 +0200
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP
 self-merge
Message-ID: <arktxLzohm0cb1ch@gmail.com>
References: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
 <20260920-fix-dontunmap-partial-self-merge-v1-1-6ffb556f8f8b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920-fix-dontunmap-partial-self-merge-v1-1-6ffb556f8f8b@kernel.org>
X-Stat-Signature: hwu5s8cek5dxn3weqsnrczj31gejteks
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7D489180002
X-HE-Tag: 1790520836-459846
X-HE-Meta: U2FsdGVkX1/G8M8wdAMzm4QkDjZUEZkzmv7djNdjUV1wyURSIW4Yvqtdk34KtL4t97mZsccuLzWZjqwZwY1Qvsq8nKUBvxMrNtLlYUkWwM3OL9sDTJNxcuHZOJeOTobDr+z/U68ZhmTX2y8gVOTLStXlHQQvOdyr+APvWyquJ4G2DqWU3QgGkAbRsoTOd42gD3h3+WPRoHtzqHPDo3+l+IzsvrRhRB7B9AVEgZpij4+mUWUsFoagKmmmEYKVGoSa9t2zcoOVUjl4wYUsgZ+U871ah5QLIryqotDxl8/BuUz1+Ld2lP1lUriopDCosHaXgmf8f3cJqkiVCmH06UlFPAKn9jr+Z75OO/Ifn2XYv73jJE0tSnLMXwP5iMNCpQMaTu21XGxSS+2t6zzMyorNEoW6tKXSdDpE6BRN2+9kIlGTDbYlh+DDeOVoaZzrBR6H1LUauTNXgZSTUoZb/kWn5VfAixM9B3oHrR4uqMLhgdaR/Grx6JZ9cO3D/i1/lpx7nSCwE2xZeJgP/2YZcT80oiIMVyn+hJCmUTRqFSgF93Gla5/z4X1LcVD4VxvW/v4zRZD1KmrPNe6Cvzpfn8x+WpqOuZl46wvK5nn7rDVK7Lnf8Pc3IPVsSYJKaUXtwYSvKmKU+ISipzi4B12brY11nBdRY0UL8N+qPhgVadzHeFS98MoSBZ1ewpujqpJJ59ncBkE98Xi5PgIwZT+ILot2jBMfYtTq21DevXgHEukoxJ48FdqD5/RAUpTxNWoymk7VGgjH4l/wX+tS4EOj/U/+eMzDqz8t2CtZFjvjSKkjWq405tXRHx3fgHsFrrWjtkep8aS3lDVWfsb69e+6N/0w30/PyjFugtp06f34rCX0N28rWWDIFZ4iRaOOEJxISramk719OGZQJitgKouOt/wzCH4skKqompK+KgdIAHEce0Cm+w2FQ7OFzrWta5zQUmavCBQJ9OhkAk8IND2xVoF
 GSMwT6c+
 Y3Ctxch3DD04x+alzC2jysazu5wn3I8aCsI7ZZjFzm0/rMqcaDJwL3OvP3HmJRo3ZZwfAPqvWmXcFuno1Z+/W6FQQKvv1YZu28OQv38RLO9KI35w1pzwF9sPJ2vNQJvEQyH9MooWrJFu1L/j9NsjTuYIYQhN7zZv4cazIQRd64Pb9CzsAn9X1JP51hai9qgdADor7pOEFYp+G+uOyyn8Wps4p8hrwL7u0Tx1g5wO1MPXuWBB+FZmBgRvXVtituJFtIwqgheN/2/xhpAyXW72FSJFi3G44Ur9ghEIiV2XMbutJBr3BPZvxT7sZo/HtHhJs7P2zTATZDnQZXysTd30uhUvkK0+FKZ3UcS4FqjxHsoXw3GBqtK1hmG0zQjugCQMKrWbi/Y4bNtnITlZvwqBMnCdGk+8Lv66q6pg+mm467TurBZcD6fkzWdEuSrESF6nbYrm/6RTV/r2V3ez/1qQ2SQ5jTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 03:13:10PM +0100, Lorenzo Stoakes (ARM) wrote:
> The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
> operations that keep the original VMA in place.
>
> Historically this has led to a lot of bugs where non-obvious interactions
> occur between existing mremap() operations and the original VMA.
>
> Fix another of these - self-merge.
>
> Self-merge occurs when a VMA is moved in front of or behind itself and the
> attributes of the VMA permit such a merge.
>
> Practically this can only happen for unfaulted anonymous VMAs due to the
> page offset equality requirement for merge:
>
>                            |------------|
>                            |            |
>                            |            v
>         |...........||-----------||...........|
>         |           || unfaulted ||           |
>         |...........||-----------||...........|
>               ^            |
>               |            |
>               |------------|
>
> This becomes problematic if the VMA is configured by the user to
> mlock-on-fault, i.e. the VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT VMA flags are
> set.
>
> MREMAP_DONTUNMAP clears mlock flags for the source VMA and maintains them
> for the destination VMA.
>
> Self-merge makes this impossible (there is only one VMA) and incorrectly
> clears the destination VMA's mlock flags.
>
> This causes a leak in mm->locked_vm as clearing this flag does not
> decrement the counter and the VMA no longer has VMA_LOCKED_BIT set so it
> is not decremented on unmap.
>
> Resolve this by simply disallowing a self-merge in this case - the source
> and destination VMAs are kept distinct and then are able to have distinct
> mlock() flags.
>
> Update dontunmap_complete() to make the now-redundant self-merge check a
> VM_WARN_ON_ONCE() instead to guard against future regressions.
>
> Also update the VMA userland tests to reflect the change.
>

LGTM.

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

--
cheers,
jose a. p-a

