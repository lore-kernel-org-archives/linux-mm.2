Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C758107639C
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 19:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35BB6B0005; Wed,  1 Apr 2026 15:25:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D416B008C; Wed,  1 Apr 2026 15:25:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D235A6B0093; Wed,  1 Apr 2026 15:25:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C46736B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:25:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 844A716010B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:25:10 +0000 (UTC)
X-FDA: 84610965180.24.9ACBAC9
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 85B331C0003
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:25:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oQLYwOnc;
	spf=pass (imf21.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775071508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E13s9ySbYGK+vB8GX2N0piibVYX27uVfmrQEHfUUl+c=;
	b=dTTHGc4s4y/PiOEWcZ3+gf6HaIjbF503no+fbseGx90Hjf/oZrAPb+EtXxZZZEPZOQ5dQM
	TQib7obTQnb+sNDfG7XK56q2KV/pqdVB0lOrHzZ2NObDBe5ZKjmnRji8L6WC1gJ9Kx28rX
	7nhcJ9RqcD4L5O6TsaZ5zzi0O3UKNL0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oQLYwOnc;
	spf=pass (imf21.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775071508; a=rsa-sha256;
	cv=pass;
	b=hOsodFjJOg2unlWkX9azmiXUsgflYW+QS7mlEqtllBtHcaqCtiZymzh8ALhoICEsvvH0UX
	G+pvU955vYI9oGhJzym1PWVISvdBBDzBAssBTVWVAXOcHSjFmw0KgeThjltC3saD+YhvOg
	TIK9ljJMpWOs6SL60jtY3ocZKas/tQk=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b8d7f22d405so16290166b.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 12:25:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775071507; cv=none;
        d=google.com; s=arc-20240605;
        b=ao5+b+1C9uJduMGGXjxXKEji8IAcMbmGAvhJ5EOFopU0viYrkh/RVxuoPt8ZfaoFyn
         c8ihrveSPeL5Q5b9PCyu6kZlVIIb6OzkvcC3KK2jfkeEHXzjZ/6/I0+4dYiXw6s0T6t9
         WGLLFxS1T8Cy82IyOy5EAyisiuqr0YZYYrO7l5Xwf1NfK+i59S69gizS/5xoU/4eOJoy
         oNFVa6kMSofk0UXBIcG7XGWvF7NWUbJgbLxGp9Yfs7uzNfv77V8y/q8I75XTRf7f360e
         n8K09ZPb38+ehshpGQqNpkyVZLLJtIlNMqZEarpIB2X+UzWrvhJqzVYtIzGT7IP2HUT+
         RZyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E13s9ySbYGK+vB8GX2N0piibVYX27uVfmrQEHfUUl+c=;
        fh=gS9US7J0vdWFcllasrNKp9YJ3ZTlMmEUUnkDg4Yiafo=;
        b=TILC0AJXG2WjaiswmlJHatfvTTW47PjLUuF15ApcQ8Aa83PZmMiNCGCcpj5q5aPPhJ
         nRlk18HSZ9SqbhDaUN1G8RU72qwOg8KYqRlS5JsuOkJzEJ47gx346CS/HTQoFg4NAnHj
         AIz0ih/ZDXRFY+VUKEru/e8pK9ar8jOfCE27Rq2Nr2zksSpvAqrYDhSMPLUo77ArbwD7
         +hKv+f++S0oznWUrsoq6pdRf1O2iA0eIBT0k2XMPR5GMglPqlR8K6jOkjW+asHAFS/qr
         xL9tHin7zFthZveoXu1yOsWOkeKLRO1fd2P3Cc5nM61eqLlKV6MhK1S12VDDP0qYLS9Q
         1YUQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775071507; x=1775676307; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E13s9ySbYGK+vB8GX2N0piibVYX27uVfmrQEHfUUl+c=;
        b=oQLYwOncBq16CczWpUlL5hPwhSNYt4fxloSBSovQs3L4r/RVT9njpg5xYTG4YlZgX/
         Zad2W7FSzXek6LKmdIb4zjmHJNbcIU/JvxUJY0jiOYB6ks+A+wR2B7s0Ys4aZ1BGFGwy
         l/Dj7Q1ZILBoqT41pmFbgrRBqO3aLZoa4DaQuzBh9EE4Hgshl+3prO2pBYqXfkRu6UOz
         9Bx/I0cw5T9y2nlGzZ0na0q1+l4zN+SBJgWQJWvUCsfvPQYJ0EweE+E3QBii+3F1x/+1
         8DDe8TqyilWqbt+ARLmN/ozeyLmejHjpRbi4aJYU8uumxK4gNAHVm7vEQqfEsn6H40cc
         oqsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775071507; x=1775676307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E13s9ySbYGK+vB8GX2N0piibVYX27uVfmrQEHfUUl+c=;
        b=rWCaV45QVyFjNkEaVpkaoH27C5DZrMVHx2v9hsUplNOLT/H2AHjUUOfAqV6xirFVhl
         6jbkjWzhqiN/VEbKwVvNq+a/PyOKhwsHrSHIclAehkQZ2X9TngUl0177lvaOiD2qSTys
         fe94mGfKrLfQYHgRfTbUYmeT6Fe6lzi2QunodDsK5u7/BBWAwt6FOdNagE5LKIUwc9vM
         5P4cHeNH0qqLLy6cNzknDLB4vd2hEIZe3oCiiw8Sqc1emqHvCVGsDgzyKYlNoP0nHdIf
         OnGdmiUAuNqwhghJfgf1NMu557ammu/mpqkJ/DUxiDep6LvjBC18HFK7BS+itlbr13y/
         m7CA==
X-Gm-Message-State: AOJu0YzdlmtZxPy0srQbu3yyny/UuNJBC0H0y8wA/vOhhvyeQlKEtzAK
	7OpoQrWFL1E392CTlXcJI66Pa6JMj8SFnT31e3WZA9FyNwWg5cCMsHkUaZky+TMkfwde3oi2naG
	Vm3iAWzjHZ0cqiHVrYhBIHM4EMuUKy38VV/yC
X-Gm-Gg: ATEYQzy7jtgYA60DZ+FjzWqPmZCQ3kJ9erKw9wsIPFOMbp29GH+o14eneXTNtiBWMBU
	gJJuNL2kLLxngfQcOszleU0XcV0fxu1Medq6CUiBpmKAu887Uookf/ybelju+5HeeRcknKQZ0Qf
	Ya8fFRLjw8hrYKhsXFQS0xcvdl12Tm0mVnbwAWCInRbWwE+QRMxPGl2Tpq9ipJ+/K4i0T4MFogy
	MMyhULoZMUzq/Fg6FkK7EHyHiBOrmntWYOVNmaBHBqXMl8Y9tZ2oPLzZyQ5WrucgW9SeXzikAcA
	586ENBojBH++jHh1PVKahig3Vj1SNS04dJO1ubY=
X-Received: by 2002:a17:906:f185:b0:b97:4e42:23ef with SMTP id
 a640c23a62f3a-b9c138f8b82mr197503066b.16.1775071506521; Wed, 01 Apr 2026
 12:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260401131226.4011156-1-mjguzik@gmail.com> <mxbttfswskgpmgakwz5cja4u3gzroonkqcqf4yggybtfolp5hd@qt7762avy5qf>
In-Reply-To: <mxbttfswskgpmgakwz5cja4u3gzroonkqcqf4yggybtfolp5hd@qt7762avy5qf>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 1 Apr 2026 21:24:54 +0200
X-Gm-Features: AQROBzDmvawUl-FnIaJ5z_jO7D_jhr8iGXhzOvIqVvQPx8Arl9uNEtrOD8qoF80
Message-ID: <CAGudoHEN+NMizX3yF8bDsm6+y0-jyFb5-fFogHWs3=F4MaHOPA@mail.gmail.com>
Subject: Re: [PATCH] execve: block Emacs binaries
To: Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 85B331C0003
X-Stat-Signature: skjt1rnfy3hupp8so13w8foyq7kzrnkp
X-Rspamd-Server: rspam06
X-HE-Tag: 1775071508-574857
X-HE-Meta: U2FsdGVkX18xSrrzBR/HUcj+CZEUnrWN72pj5l8iF08Mz32JhHPYNL8TP29xVjtXPLRyyZwsLtdtH4aNyhmuZmfwItjysnhi6ieGz6sMcS/LYS4AgN8TZye+SAfBeAtMVDYKXmRoaxHseW9gDIEW4G5GTGm/QqJwrOUpE0gMpHTX3B+4ZK8mra09hQmJuAnS48O7n5s8yb8OtM2g/jwaSUgRC5S3Tw/RhvZWd934ZRvdDzNdBDUrrp1aAP07XvAUbHUrh0FsBvh8Ja/MyO9DSJw7Z5VGnq5S9yaBBUfccYPhcXwpbYeIx8bIGnIVyJ0hdROcucuIGeCO2gOs1WLf8BiHjchIx5HGfEet23wjHCbPO+Wpbi8gHg8Lh2oylYg5GVYwsR77F533+mLvCGmZZA1iIoip12pvL9qYEjRBk+SYr4MTpI7ZiE9PXs6hvy8dlChBdoNw7kB5+d2PyX/f1HuM7VGCIxdkmAE830s6PMdJaALPcKjsxvKgorBtzGaVSj+5QFPOlQrnYhaM2UhJxGwW7zafjLeb3T+3+T72BUvK/9kVsx4HkT+krGKb0AJN/rBc65zKymSfePZlO+Zcxb5CsxJccLFl9M0mEfP7Blxsh2WRXKWQjCrvNOVitdrWHKARa8iOwGWcS5uWcNGyhb098v3d0VJm0r99QyhHE6AtOpq6/S8hpF86IOdHYuJ1DCKtvFkrmBWSEhnlPgnZyZJd83F/pTBDMk/hp1cIzIfs8JQn0fUHQX3dliTdGJUjW1m2i7ZWN4pH4PhfAFij9DehrlyZ43knJL8sznYEKGYjX2tLTBnx219exzXVUgSPlS+fddUGzVPAgfOGPmoh7PK02JfQkPltKhmhXKAeS/YejbW9GwlmcCEgKTi33wBrXPHNaJB3YiL4A29zEpZFfvSSwsBN67YUvA52UlySfrJcogxCZV0xh7BK6fG2vtOTMkwLqBUjNQ1mDx41UAL
 OCogJd0q
 ssEvE21KGD/fwegYDNOXABf6lA3PYK8n48AvB+YfUCeTKQxla1f5wJ+6A6bJt+be4oJvGKXwQZkoYiCEXRTIMNXGxiQbuyTrOPLwfJcCrWEhaE3Zr5LtGq9AI6i6YoFvD4X0twFWf4RysR9BqKxnIMJx3c8+4hrv19Tpt+q6KFl6n2oYNlw6ACWkMJo+D8CYq/1Lk8YsNeAfQAQmiIOn/8I1INrL2XPFzOCOSdAMK9TTWl7cGucoijztm3sBEOYhkpAte/w8f/cT64q3743L5v1eL8O79a9hFQyIgdS8WMbJQkaHRPkf0HlgfBj2kVbKtrPAOp2FvJYGrhrbMcrhoiQyYJ4LwE84udT8jI81nmJgdP9Rj1kStSqnwZoyRsCwwaHebKfw6AnHGY2iLj7Kv5ERdvkzqITOt07/bg73OwXYjV830WJwjm78HKkW761hf1rz4iA+sipCziZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 1, 2026 at 8:37=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> wro=
te:
> Can you block vim too? We only use ed(1) and GNU nano in this house.
>

I heard nano is a company-issued editor at Suse.

If I wanted to mess with Red Hat I would block mcedit.

