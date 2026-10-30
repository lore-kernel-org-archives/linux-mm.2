Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180BB606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mMUzuFyD
Received: by kanga.kvack.org (Postfix)
	id 03A206B00EF; Fri, 30 Oct 2026 12:37:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 012536B05B1; Fri, 30 Oct 2026 12:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69C06B05B4; Fri, 30 Oct 2026 12:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B95416B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:37:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 370A41C4112
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:37:32 +0000 (UTC)
X-FDA: 85379848344.29.887CA63
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4F83FA0002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:37:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mMUzuFyD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793378250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zAYL3j86a7Q88ddu69k+6OJol7/H9flq8cPsx2AHE54=;
	b=IYktIZ4YrZoBjmWan7a95x9G4aairIG3vKsunM4eSTMPbA85g2Yihl3Q5GqdHeovyf/2M2
	TCCe264Y6/T+j5ZQSb+AqgyEEQWGsa2wk3vhZjqekzk/QXXKXJ2RUYYOej2t94Z4xeMHl+
	TcZ/9DOwSODH87tD7bclDXbpVE/o7eY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mMUzuFyD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793378250;
	b=IoTvrOLVPGISng0dFO+uW37gU/PZLLfk2LlKqH4T/eXaOdsnhgS8QWDIgCu4MQURGEVua4
	06rZZhDrNQxuVAlUZ1+VmMKx7fPWXGICTayMXEusJ5YTpagALtJ0AzjI4+PE/IdyDoki5z
	GUjD5dKYbeTUp1t2zmB4tbtx4zfTZ7w=
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5ebf39def3aso311424e0c.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:37:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793378249; cv=none;
        d=google.com; s=arc-20260327;
        b=h0DeA+68INHpUYljDRj/Od2zlNbf6BogzIXGO9FNwYnl0Is/Cgru/SdSdVDU5eSMVw
         KmrPgeyaZRKnrARG/tyW18Bm7cK2Km16P5hIl9lBOGrpepHsxXvmEjlNLnB388HWfBTu
         8nU/qIveHIcq6yLiIa5RQJFafN0RGa2OhPWPowD7F/+m1w+kv5wFBjhLOkhRGESEuQjK
         ReElGisvHhrM3hmpG1WGhlp6W/qk9XA7SjlzdLLhdis4d0uGtsHpemVe0+X4LNT8P7cw
         0X9dxWHugbtkwYGDSXftqI+ubIuXRPeg+l5r4oZl0BNZW0PGdeI/YBR+g7AReLvcXENf
         yuxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zAYL3j86a7Q88ddu69k+6OJol7/H9flq8cPsx2AHE54=;
        fh=/ZtYuqDHd4QY+2MXTNCDeIPMHAqU43eM75AiTp7Bnns=;
        b=Y62WVLICdQB95DsbX0/6GzcM8SHXhiKAzCBcSU4nRsX0Kd83xkFh8gzkdcuwQDk89M
         YyvTL+E8IWnX4y7Nb2yslkzV+jMy3XrWv36GepzgUagvVOpZNoupIVBxGrwR4wC9Bzda
         /u4hJvhkWrStjJlfclHQwiVQHHjJRbabsxj6NVhYlyXGzDGYnrTDlpqc12q3ggvdpY0D
         nxmWtttPavDUHcxR+xvS4AadgeIAObzSDWbO7rNzLR/WHRMx/z12X5VT9ovl8/IzBFk5
         exn7bF0MKcSBGD4svcoSk6nxxaww2ql1naNxAcwmr9woXwL6cyL4ynvBA13sKnmUnwH+
         RTTA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793378249; x=1793983049; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zAYL3j86a7Q88ddu69k+6OJol7/H9flq8cPsx2AHE54=;
        b=mMUzuFyDzlBcpijS2OzQI61F0PX973cebjuJPRE+0ZC8r4KbekmpzzhC8W1X6Zs+Ty
         clIP0tGmVapvjsX7o90GY8BuGRF0l1ZpT2QfRPdUK7vZLGeouVBWR2tQELixYa9wdglA
         BRrn4jkPupFjnjwB4wG2hfYk/hViUTLaSUejAli75d+FPSKZwgc7qsMwyOTFZAbGWY1y
         i9q+oKHyu27olRU89NN6rW39UdVdUI2s+IovfRHhYZSFkfKsh1E0F7Kjz92nQ26jqI3Y
         a8E3SOL3BF40diEwot5dKVu0NYefEzH7p8DUkcyJs4RExJ39F1V4LBYI7MgwJ7ECJ20x
         zNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793378249; x=1793983049;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zAYL3j86a7Q88ddu69k+6OJol7/H9flq8cPsx2AHE54=;
        b=v90IYsiW12vHEBRPDy9WdEcP2QqLWMVzT07C4ssnKkVWI2+uUdMH+1EiLP8xKrQoWJ
         dLrRURI4uYUfm8h99Tk6oTcxjOzjU8e0IK0/HRbj2EDhzfbq6hYf94arK9l8JyQ5ew9l
         psKOllW3MCwpcNaSWXs9tWQqp7Arw2G0QlI4iw8RHWHJpJfoe4fY5mSpAOgPAicmSR2i
         jLwN01oEhXMKWyp11AMuX+bI3rwzqJ7oZxKQ7QSk9tuIkUEV8wIc/IkPGGuOLTeSBYK7
         5CglQbc6TLIZS3PDbP8FmerVDBMU2Anjyn2HKfI+/oNl/ATfDXEQytUeK/IWdkjDX6pn
         WIZw==
X-Gm-Message-State: AFq9FYJjcmcV2xNs/gSWjbUwGPD36/O9Gii/+vd6MP35cFn13xNNW671
	y+nCpWF8rgyrUywCnz1T0PEqZgEOjk8n5ORh8hJX45SE2N0kEq0g6wRU/TPgvc8LDgz3Bi/v9px
	g3u6bRL7krrwXnOSBA9MuZzbwX8PmSaU=
X-Gm-Gg: AYBFou0/GIfh0vhrowbyHKMHpl/n/8+6Ia8HNxjrwYPgCjA1EV01APmCSO5FPBfB/WI
	VOYmQeYzaeBktlmu6M5PNoGdUbc6JVDqqE60A6W7AWC+SQpqUULLL0QimiOreIoroZ+H7N6l3JY
	zSBFdFMnKlq5spCqri9CIrAMrR3L7OqJWQ5TTiM+TTloUqTnXRMlgZRaJjkM+/ZK3gr6TUBgQvE
	f65IhTUUWwc/hxuurewaW6uXIWSj2RLnJNfftiri9m2Cyfm04oyM5m0WZXO//An5TyJ8nDyDtKS
	4BRLXqd8MYwaXMmrHsde/rchEZFxAfILveUvExOPlBffl1hGXT2sfrRqBONYnTPVXQlxfquaifU
	D/W3TWm3uJbSlMusbq6Cpl/Ri3XiM3lnpXjuxOENOlQhShlHpw/og9+X7a2LY7romIyRyapHC3P
	ewZ1u91Zf0
X-Received: by 2002:a05:6122:3d0b:b0:5ea:d1c4:7cbe with SMTP id
 71dfb90a1353d-5ec6899a08emr1698294e0c.23.1793378249305; Fri, 30 Oct 2026
 09:37:29 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030161046.1497894-1-gourry@gourry.net>
In-Reply-To: <20261030161046.1497894-1-gourry@gourry.net>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Fri, 30 Oct 2026 12:37:18 -0400
X-Gm-Features: AclHuK94a7ygO8e952sy9QWMqMjYz7wrdIjjao0GQyAzyDD8wGX-wdE4eecWNOg
Message-ID: <CAN+CAwNsU5cOLvvHttz=9FOdqHEy62cmvVmJzhL4_1EhHwfyVw@mail.gmail.com>
Subject: Re: [PATCH] mm/mempolicy: use one node set for interleave weights
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, rakie.kim@sk.com, 
	ying.huang@linux.alibaba.com, harry@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4F83FA0002
X-Stat-Signature: sfotdr4yxhh54aey36xz5gbmx9s3y4kk
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793378250-525594
X-HE-Meta: U2FsdGVkX18gWIGSSiRjC2kVsmYyN76ScF0jDLzVtDQWfnDJsGgonK5y9nSmuqkCF4Lqb4wySoFDa6BGuh7MmlVZUY9xk4OVQgRxQHIvNfD69Shvepqh0RQPm6tsbeHsYcKvnjl1ARKPxmNcs9Tjt0VgKqTwMQ2Y2W0vwYTOaE3rCBuvUqREhL9KFBkHkntx/OgGqTlCZw45Br7gfUa+EWaXy6R/9CJz19+61usd73Nm1D1aT1PLPBdtH6jV0gAeoORIoVkk9BjfgfJySWxOW8arQcIEsfKCbR8zNvZMUaia7vEC3R5oSzIg3b+2rLdl07VW0VafSJRWucqzwLB1W9mWtvw3Fz9MOFnxLwkbXfEboScL+gr5uOlZYPjS/TVMOfYZNL8Fj4UBEuq1VbqD8ap6dTwdhzarpv/A+WdA8zuHIt1MyOuG1woUn8FqkroVa6uQg8L4YEfN6FCLR6U+nKRAy//tZOCNIhXJtqkmv/aQohF+zoX2aJ+cFt18BXdZiSi91I9Dk2zSdJ3PavuolDH2qyaLbmeY/KDbIRweqdHkr1o8FUa6l19KVygLZIWRuRoDyoBqYBZVTLL8hCJLWefKoVOxQNEw9XhRyqj/rsOKR1ZcaLPk8emByZR7nwdc96t70/h5UgxFoOxRAraMfoudezPpARjoTJJiOgohic58yirUq4IXeNR2oDwuDMLxu4YuABvlA+lQkV0bDC+qeF++QnfsK8Gkux9ek4DWD+xn9zlUN66pAdMgDGS7I0R7IgfSESUx6EzU/7aD/wi6EFHS9uGZNO/CPi198BcvWi51K8AShVfyvpa9WJv3fmptLo9cOExeo8L5B3jJNx2a0F3HxxiISVIthFc47qnuco1nSjSJD2KLR6cXBZN91OClsuMhRvSfJ/E5fNyher1hhjl0LrrZjUSkxHcFg6lfvqU30VZw6kWaeLzpJsLmoC6JWSY6EvjH305QH7dlMlV
 9n9SituK
 2PpAdgrV2tmyvTfD4p6Vg2fWgkoXk//g//RX3JJ8mAAodMYLTTz+jLrwjl31qDWu7PonFuX1DBaiqq6ahL3XOrCl/O5PbDV/leh2O+zRlDoLEPMK0V6pMljsnFVpRv2Sda7AU+WCd77vqcn/TnZFnP6XFN4LzNvLo0T3HvduVpJwebKJJb0TqLxyiB4wG2irXEAZd2OpfYddZA+p+LWvI7Skwd4wxppJCoucpGbYGVZ1Zjnr922hJEHT6vyQowyvtCoe3mUOcH36Uh4VK9Jc8NXX/qXXuV1Mkm9Mm4w0H3hzB8GbqQKFtoQfiBCVw9iJ5V9qN3WayaNR40OWNzscYjYvBGno0oFlvLBcA2mKvBqrIjQGAe6rn7lv5uwEEJY1a0pAAkEohCbvS0wL8/x6T2jtUv1Rz2uwT5/lGm+Yf45P0RQejfVdjbH1gS6dMsuNO1jd95Tur8MIQtGnsKYjog4xFIB4eInwz1TXlp+RVT60ps4rpOpFRcWxVTizUQHIYsJLg63uE3lycFpECN2RN44jdMKEzUl/CepkW7T7Ahc3eaqR/EgnYnmL9CGkObxMifN+f2DoKhJtv9fug304rV/TvdfphfkVo7R7H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 12:12=E2=80=AFPM Gregory Price (Meta) <gourry@gourr=
y.net> wrote:
>
> From: Andrew Morton <akpm@linux-foundation.org>
>
> From: Andrew Morton <akpm@linux-foundation.org>
>
> Switching weighted interleave back to automatic mode while memory is
> being onlined can cause a kernel divide error on x86, and a panic if
> panic_on_oops is set.
>
> reduce_interleave_weights() scans N_MEMORY three times, but hotplug
> can cause N_MEMORY to change at runtime - and torn reads on that
> nodemask can cause a total sum of zero bandwidth.  A node that
> was hot-unplugged and then hotplugged back can then cause this
> loop to generate a div/0.
>
> Record the nodes visited while summing their bandwidth, then use
> that same set when scaling and reducing the weights.  This gives
> us a consistent state even if N_MEMORY changes.

Makes a lot of sense to me. Thanks for the fix!
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

