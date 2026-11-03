Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C3E606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z6y1E63P
Received: by kanga.kvack.org (Postfix)
	id 15AA46B05B9; Tue,  3 Nov 2026 13:08:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F4016B05BA; Tue,  3 Nov 2026 13:08:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030C26B05BB; Tue,  3 Nov 2026 13:08:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8AE96B05B9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:08:42 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 522921C2F46
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:08:42 +0000 (UTC)
X-FDA: 85394593284.02.B68E5A9
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7852980002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:08:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=z6y1E63P;
	spf=pass (imf30.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793729320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N72k8eF7WEmSz2BcB1uRCFB0Vfe7j02Fo65rhmL5td8=;
	b=vE6PUyR4V1bjjl6FVbf/JdvQRzxonFeF3YG6s80HNOjePM/SwTSPyOoAk4KTIt2+lmC9/X
	qgs3gXaDZ9e5oEuQ6soCjuE7za43qmM/pBqS9H34XA8eizOZEiM/tWsP6vGB19/CdXHqa3
	1iMi1teR0AZn72hyJHgxSlps/9eiVPw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=z6y1E63P;
	spf=pass (imf30.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793729320;
	b=oZtXUsfgToU2Z40vfUS7Xtxwg+OAfBzgxk51DHAdy6RKMuCbVpOmOMm86XrpuJ6/25YbKD
	nNip17kZXVtEbnD/GhLjzaoYP+JYCTunFm/0pQH+ovBbwK3V5Suu7BLQyfHrYgqyR9be/2
	JRo98o9yJ+WApJdAaki3VvN2wh5g+Dw=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso3066671a12.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 10:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793729319; x=1794334119; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N72k8eF7WEmSz2BcB1uRCFB0Vfe7j02Fo65rhmL5td8=;
        b=z6y1E63PmLKzQAEhzfkxVgJAjF06ttDQJYnG9QGVSmmDdZ/ub7UxK8gvnTH7RNViFp
         a9NBFIBzIA44h6eOBiVitvCucLV6V1q3Gk9ygcl9Ej+5oB5mhEVTtlHbIyMhYEH7ZgdS
         318TNXelKKO31407Qp0IEXov+kefnMqkr0R6/zZTkxv3ToLS4wc5MeQAbFL2SUawzjo/
         SyfJBjyFQR90QzjSNIWfA/3qQ9KwATgQvyQcW2cK3qE+B2fCU+f4L6rmDRuHYl2oNDw3
         H+iXi0TyZyPqp/0ayB7yZ+RGlxifqQxHtOKZ86SznBqcOec3TIJFYl+XZtYj//aENhMU
         tZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793729319; x=1794334119;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N72k8eF7WEmSz2BcB1uRCFB0Vfe7j02Fo65rhmL5td8=;
        b=PNZa0lzmq2wa6AY0u2Z8Y+wxjpqMxqIfBVQCKpU/mEmFNiAokiiORnt4T6nVlcRum0
         ypR9uO0tXseTiFP6vozWVOxcPyrqufWm1dvso97EOPHI9vO/ACmY9MXQgkkp9wsBkRr1
         8E8e+/47T5vXNh16e3nZTjzvILTNjol4cGE5mWXVgeUE7775H/JZBXUkK1jXVjfmP3Qu
         jW7ZQ9XwwZqmcoXrP+GfmPi8q8zIq+zeFGOruBtnW/Hck8D+RGnEKhZLzR2+4CEHwkoy
         aYqgHGt9fzMsIp5HDqKnrPwg4B6jqTpkBKIhcsyW82c3AL9LoGeNXmTPE9rmnQhetBQw
         Q+Sg==
X-Forwarded-Encrypted: i=1; AKwUvBxE8DNWC+80HVOznJES5/CRxMsXpdZ+g6m46MBvjhhGSXukJ8CFEIEHQuD7OYvU79IAUmreG1tn8A==@kvack.org
X-Gm-Message-State: APuU4Z9mYuT7PPqBdMnTlbtrdXc1Hj0FrhbYYzD5Y+2GZnXFwBVIFnD9
	9Cf/LR3WLRYIKEamlEzj4ihPZNCIKnNBqQST7ev48oUaxgHUxLerE45I
X-Gm-Gg: AYBFou2QLrJeYM1qCPCbarhomryr4ddJvfxeXur04RlQovj8CeYiQxqFtivhmHjIduv
	ChklRekt3bRNAHcAQtC9su1ujTmVrHEvyJ30yeNnNLu8mIqD290e6TzZo+DEBnhmRZh3eDkS3Y1
	dE81vaN+Y/rqM67OUmhF+PpxyHgR5WT2ESh3OfQ2o2R1GKSF/wdW30KTd1G5dmY2zx3wUQzGTdt
	zTdOwViboEucNzcQJXyTY+V7yAZnZipRjq+A867oOLhjVeNk++brkEx9C8+LYE3KyM2Zd32Zx8H
	de2uSbP0mgkydIIyRcm3pBT4DS5ZvGduyyPeOQLXdTyG2ismkF6kipICpMkmIme3PVzvxAsSoTG
	0CQksIUeRglFU9wwcKBK/GyLw9mbnBTfiGydPyp9yrXLIbR7UO6wq7QWPi/dBWRy9NhbcDf5Wpo
	mt3wijewwWrcIV5qUrXcpHMlukeq5WNGOrwVQYWZL2ZN2vXrMqV+qS3FUTeHSRHWZfH2DfcNs0w
	ERDmAOBGV2OZrKLSVsK6fsTdXzbAeJjJsn/51ngk+IgYK1y92SDkX8jL/OLr3JokXWUm7G+Hu6+
	Pc6++t+LYUtY77Ya+r6fkEEQyVwXQmT+sOSvxfqn5OeJKzag+KhHYim9T/Ttb01GUYulT5cELp7
	8j7yI4QM2b5XdM+hTH5pUYjWwT0UYYirx8MI=
X-Received: by 2002:a17:90b:53ce:b0:3ad:6090:a190 with SMTP id 98e67ed59e1d1-3ae89817b01mr11552362a91.41.1793729319002;
        Tue, 03 Nov 2026 10:08:39 -0800 (PST)
Received: from localhost ([153.61.198.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0945104dasm77345a91.17.2026.11.03.10.08.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 10:08:38 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Nov 2026 18:08:37 +0000
Message-Id: <DMLRZ4QCSGYY.3D2G6VQA28CBQ@gmail.com>
Cc: <bpf@vger.kernel.org>, <linux-mm@kvack.org>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "John Fastabend" <john.fastabend@gmail.com>, "Federico Di Pierro"
 <nierro92@gmail.com>
Subject: Re: [PATCHv2 bpf-next 0/8] bpf: Add user memory kfuncs
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Jiri Olsa" <jolsa@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>
In-Reply-To: <20261103075916.100050-1-jolsa@kernel.org>
References: <20261103075916.100050-1-jolsa@kernel.org>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: u64r75tk3mmaw4n1uwgek74eftowwr58
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7852980002
X-HE-Tag: 1793729320-742001
X-HE-Meta: U2FsdGVkX18PoT69R6+CLmBAeoW48U4l6nicNdQLGZJ+fOyXuf73/5iAXbch3UC4oRlYgBHsm7BJ1EEcCgUmupvTYSLE4ez21Y7qETnxQnO1JXlS89LrQPfdnW6Wifta5eC/iJ0uFVAlX09luLBbkzS0ueQq8ULzu0gq/lSYCw9m3aNcVb5YM9cXkM/FK0O71qggowgriLlJ8USvtD+33OSu1HaVdo7JfOPDsQ+0foZCzqQdNy6sSeUgpmAK7tadNEdT1e/RutR7hHltXBsVn8C2DoGFzrDkiHdvwEj4rThncvwcVi8BwILsJPKRyf+1Oz2Sbq9xYnhDlcXySj0wSXlsIfFObmYphg2JS5gJTyOt4pnhWh9sgRu3JM2GSMHtHgMvisaObsV/FoikIuWackYzaeBnoAnAt+RW5lRv7FQyHMtBWJH3wa5HEGzzOTHmAUgzOPWdwkWZtjAR4vegOfGXsQHdW4I9BksDs8oeuKsGUwTY6y3fMe/afzOD4R7qK8K4z3tiooD4GSxqIcBgFT0FkfLmFyiw01vLn7ZdQ2jVTyGjZxrqKQtfUBoQV+GVxo5W5WZxumXaQcPnnwZf0yjuMNs9RK3VooIu+wvZhhhE8/XKAQabvKwMflCaX+TWclj3MPsIdDlD1mC166EMXWDSTHTRLUBAlnuCT+T8PqO7Nud2/TdVy8KDFb+B8of+ebUkTqafg83xVLJZL+qNkxAtuYd1pwWBy8BxanYPSV5rD8ScS3FbeyM4R68Qx+sld+1PH15kSqLPOfLEIDG8TLT+rQHd/jXFrOEGc6qij4CZI4GV+qkok9AY4nP7Frz13Uj4v1ZILjhr9KRKAaTnZYA7rwKNbW4siGbw9Ov4sHcLyBiE4HaLeF1hmdujXYYDN0LA+PapzIqn7IE9WXgvcJnE8qyHJYCThhO/6YJQRgPT9zK+Cxz/rI1S2rNZPigH9y30HltByT6ClMPBxg2
 uXqAglZ5
 SpRhBTXkYO3owexQxbgBhdk6JN1RbBbOPasQq+jHH2ohNPbO9SAbBd5vQ08q5uh4Gx3oRv7gZ+TAS9FhANqjqWUwbuDjcHiOYKpXaAOf2IHEpZUehnbH2VC+7ezEUD6iLG8a63bvp9gLF5V9ANsE25Vz75o8Z7koaUdnxHEPJOUowsXoLuSgyMon5p7EGUriNxf61Wfm/RLvPgRq3wb2Uhjz2mxEAn9e7gsrOuDGytyISEjpt1zFe1b3Th1cd9Po3zLQtyl9Q7hCdkFpJR2IIOQd9gb0vZB+9EIo0og4ltAYKE7nDBCjREAP65eR7sKzoKsfpC5KRXfnp6Sqp7BCGo4QX+li7hemzHY1e4NyaeCo0qlLVmXaYrs2NN5ts39tc8n2SGKtxbC5aJSXdtwYiyGWJuX1HCzlULFpD5D3vkdK7tJW32cuNm2SQN6AliCqLVR+Vrmrg7BZsMRBH9uJpLJfCbzWc1mR/kMxe6VI/HReRKTrXtz7n6xMlCBk67cPUvnSO6XTa2iQ1yTA/7R5Mi6J0Uo8lbyGtQZLJXjxtATrzj0RwgHVWcfbJG1QIcmHC9UsAbOyNBwWFk9SYOXsi4m2ojnzS5Fk/rMlq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 11:59 PM Jiri Olsa <jolsa@kernel.org> wrote:
> hi,
> we have few use cases where having the ability to allocate normal or
> executable user space memory would help (like to replace function in
> live process or change environment variables).

Too abstract.
See
https://lore.kernel.org/bpf/20261016224310.3135990-1-alexei.starovoitov@gmail.com/

I don't see answers to these 5 questions.

