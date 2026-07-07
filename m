Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A37ADC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D69E6B0005; Tue,  7 Jul 2026 09:05:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886D66B00A7; Tue,  7 Jul 2026 09:05:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728DA6B00AA; Tue,  7 Jul 2026 09:05:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 455D06B0005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:05:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B011B4043F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:05:01 +0000 (UTC)
X-FDA: 84962000802.27.6FA44FF
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id C810780009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:04:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="oFvwoUO/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783429499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qa3HvUOBiikHOm2hv7akwkWqjggqpxhg4jyWQbcbbM4=;
	b=hKXyseIzzyYZCEhwt1MbjErNuyfcS41VKf1bqZjeDpJsIhQYTDw0TnGzCag/Q6jCC0uQBB
	3R3icUKOuM/uDxs2/QURFRbxKpefJdogPNgJECdOmucU6veUjwz2jRZTk8Zp7ZoW+ZbR9y
	xdDW8GmFyTKpDg9lfnA5gfWDaG0xPjg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="oFvwoUO/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783429499;
	b=l00mAECQXIzwrlQkp8ABWhDnXP0X8X9ajLtLLsAjLzl3wy/pDGIjw74Bf2Q677A/JjzpU6
	ZGxZwkAKC1/422qw+KfJ1FZ7beQjz9ztROeuFY1UydwU6yRio22tk9cD0ThpxLgrePq3nC
	T4O7ReZM5R/W+YZBZQ6OOBDNrBUt/Dw=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493bfe9f886so22847215e9.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 06:04:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783429498; cv=none;
        d=google.com; s=arc-20260327;
        b=iMnjpxH1zui0/D3Bfb/85Dk6PHrNwzcfwypfMimrn0/0943FCga+UzQJNc52vkIWTN
         mn5RU6Z8wzFgwGi6bKk8qYMLvgiJq8tCpqOBG6aXJMNd3eO8TymZTc95E5S55mr2a1oF
         YKY24hUz8iH3z3YLE6aFFEWDa6UAmv/kkNvQHGeUkF8a6G/utOAiFExTwXl82p69AKbM
         NWfkuTALgmbTUp4gsTOh2NuZU/6xe2dVF/WUjWAp2a/JI1/GVLtk28ywwuQWDgwrquO2
         uAIqqcsIZcjdtS1IgH4GxkCXcRf6vrqZaRBihU3IQXZUOhqJGoiPhs7fVSPggjCeHMYw
         cc+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Qa3HvUOBiikHOm2hv7akwkWqjggqpxhg4jyWQbcbbM4=;
        fh=Iy6Y30bQaK5Cou2gNLSfal3wybF+yguxgob56U0s+FY=;
        b=auYjhrnw5vkYgUaWJE/MREd3BvOXhIac0GSOVO7MQaC6+R/B1LBZ8XT3gS6oMno42P
         FidjrdSdVu+vPqlK9SpVQOt0QKUuMbPL/ZaZThnaRBUC+pY1dyboayaRg3aQe+7rklx/
         K3MqZ31p35UMIwu3Sy2qan69HzAsi7dOX/ohgJEGNGiup26YLCeDmJlUW78c3RSwzDsl
         V4kySBB48cSMFsdmEx6KrrY2wyMXFOyiRNcQChfTJjhPtPweoRdpe5H1CUi8mEgjGpMX
         kz7q7d4KVapKIOjt5+k6OT/GQl2RDXvZ/OgOUB5PaNSM/G0TcTIO7r0WCmrbuEz0lwMA
         GL1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783429498; x=1784034298; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qa3HvUOBiikHOm2hv7akwkWqjggqpxhg4jyWQbcbbM4=;
        b=oFvwoUO/WIUvsK1BiORtkwuAQ5Xsg0z7+4OmgOd+mgMnr28MPpxgNer3Vb7uEfiZpa
         /WkzHKt58SdSd/0nO5pvCWt+M2WtQhs53xTd2++IoehrSUwu8zYznQ1YMiSEPyQsxofG
         99z8NyQ/87kfKHYvWX7Bi3h43e1b12lZIJjhhJiwpWjls3tY29TpxuLBuZ3WZSgK51zJ
         abn9OGzctstK10KNutbBcWU5cfOKctUUgHqP2x5B9fHc7UBIXaPNqd1bO0tRLlgdiidJ
         TfLk1UxgFvuBnC3DR3Ng3XzstOL9yAZaJx0vTCxwLLJ7HpCbFQ+AWkHFWJr1j4uwempG
         iV7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783429498; x=1784034298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qa3HvUOBiikHOm2hv7akwkWqjggqpxhg4jyWQbcbbM4=;
        b=RfXeN3mF6r7rtRuHEX15bXbVJBefcTVJKl5amoeD8OQ+zYbJSn215p9uChTxMOxn0z
         gQF9OK8uI7kvnTeQn/H88vRNeXidwCWSzhy4pw0kCSyB8Ujs7qG8JYUPCEGatUdd/l9r
         jdC7A8GfTYbN/jXLA1a68FAIbrG88M1ueYnRANDFLt5sJKG8PmT9Wv4e917RFho8qFh9
         MtnZODzBjFpWvmxhT72cJKQMnSTlWBr9CxntRlL7ISZKVYzy4URONwLIApYXL1Y5CVSR
         vmATrunltgxmGK7J0QGtkWj85RTeiYjmgfdjxwcTMVvdDIeNeKlK6iEXhTk/rMS9IhYL
         gI1A==
X-Forwarded-Encrypted: i=1; AHgh+RpvPoeTgfmMelHCzbPzwNSrlrZhUFPrw46CrVvzJPksyWyvclaheP+8u2sZL/V1yEfy5hZlr534Pw==@kvack.org
X-Gm-Message-State: AOJu0Yz8WwdIpOHRkdkZxTxqZ9JkabN9149OjezkHFxr19Ilb/wTGr9R
	U65xuyHOBEy8NUZMNpHOVzxCuMKdzubYcqy9W7BrkTPwPFnTiO6y2b67dBtQWvJPyJxeqprQVqA
	PemO5GbxdeBvlYj9rq8BZxBYyx5MgjdFS/Eb0XcWANhKcVkyA5/wQGEN6
X-Gm-Gg: AfdE7ck4xL0USr4Xd90lufBP75dt74JykBsYTFem6Aj3C4VJoTJQ+4axHesbuFlyLfu
	gWS5Q5DvRMAteXrpFT3F6jh8PFo/+dlok7icXDVP3v/8NNJa/16VyUa6SvGrgAVX91ImQEI1QG7
	mxI+AWvFpljVvx4KWMZAs2dJQgflGbT9LJVMm/vHn6eBqCgJAhC6lIxGrsF49y1DAkQR9Zlj+vm
	oIXQQVfYOj1cRRBRnXeI63xaV14qAKXKPogxBIUgP+6GbcQTRhmsRBJo3NyiUM2GJeTL0bqksNb
	fx9zMgnhR2RwgUbVmGpJunBhRBs=
X-Received: by 2002:a05:600c:8b70:b0:493:b6e4:fb2b with SMTP id
 5b1f17b1804b1-493df06e943mr52096855e9.25.1783429497735; Tue, 07 Jul 2026
 06:04:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260626-unique-ref-v19-0-2607ca88dfdf@kernel.org> <20260626-unique-ref-v19-3-2607ca88dfdf@kernel.org>
In-Reply-To: <20260626-unique-ref-v19-3-2607ca88dfdf@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 7 Jul 2026 15:04:45 +0200
X-Gm-Features: AVVi8Cd8GrEsrkEwxzhRkanTcpbMUA7MU6OpTudOnt7DIfIGqhosSlF_BI7LYTM
Message-ID: <CAH5fLggMeHUgXj7JGYSJejUrR2PdWymOOb+3E1VmHokzcox4hg@mail.gmail.com>
Subject: Re: [PATCH v19 3/8] rust: implement `ForeignOwnable` for `Owned`
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Lyude Paul <lyude@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Michal Wilczynski <m.wilczynski@samsung.com>, 
	Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev, 
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-pwm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C810780009
X-Stat-Signature: wsmwtromqw3yx4ydpcnu5jnqmr5kxb3a
X-HE-Tag: 1783429499-370473
X-HE-Meta: U2FsdGVkX1/S4ItccEx4EPc7LNmwCJtXEWJJcz7FMXHxkHYSozvXb2tVkG5ve91wOK50thEa/aK5mrNCBdzflY3Wkg2gtes+pjcKM4tb3V/GBJw6gGgiRXZbMBTql7d4XT2L9UpwPcC8IZpWH6G30GUxkUGQ/HNAFMPRbHt24rjxAtLUs7YVruSjdaJKxQwnylXXz8V3nkIn/+OfNcUG2zBrWW0NHWoBexPVU43UKLX3mwI15W0WWENJG0uE/e3sCc/geBorCVFuqltCPut1ulMgIYJosFNebmEuQfpo+Fz5Q7RVD+ghx/xP6R+OvBljrhXGuRETtc3BYdGYULAE+PjGtLoRWlJ8EgCGPCW0aeOOS52ze+ZZXcCzDT0qp7jxEfRHG6r1Wlh5KtGWHFocfSUEn4Ie1RoL909bY3iVJCxKhL8KK9vbuLZcg5yWqFIUcKp3gxmq7LOqfpFskeMld9QJ10aJwKNZy/afy/4rpaix4j8jxh/u5xnh8M2APnk3QT+3D2sL8SJWiKRXq4lGVGHvxP+hdZ3d5Z6ClbLOwoNCYShiuhlsLQdKLyJYiUSBrhIl/+vp28gsL9iDU0SXx5XTTT+OWjqE6EWtIy4wyMLJZBtamxYCRYqHriH56Fp7ucZokLTDoVYfe6cMcXzrCPfE9w1HNUfeP9kM9ByyBmC5ZX1dtJJ5sX7IJFF/aN/oSQmengNR4quvJdPquJda2vQAp943Mr6UB8Le6mEpLnNIt6fjX/ulde6fIQNRnrmYGyJrcjfgeC5BAOvf9Y2dyFK+qy9hLOhl1Kd9E0NAM4/qqz6klK7A33KwV+z0TQtlaHIt4y71sz1R1GWx8pEjdRcq2igy99M+H9pa+l+mfqJNFAjU25gTsvTalNrHH6EXfXOEEimklFbh1lJdxUKuKvt1vNtRBFcCKpw43jdGUXM9YRoPHIGSOToH9n785/5MtCfkUhDwYqGbGwdRNuy
 Of5Ko2pe
 5t64LTjDpod0rPBPFAOygUsR3Nqci9i471uQTgMLQP5nUlpkC/inOJOFgJH7n+7/MVKy7QYqPiOQw6J2yLUduhbSETpVqexc1WI05QrRCN83te6XYrET3zT/Hpplr5bJCpFgrX8zzV7BlRTQ/9Qo8GftzzvqG8DafxZGm1hnmWNcMriknZBjpYUK2nxruMK9TyCObUfQdJKd9Z4kOIDuh6BPp124yerO8Sxejg4qAzIVQ3W2MQMzpPBR5bHQkFk/RdmcUCZJ6h+aJDFRZ3c+WaT3yeyf6SYMg3ph9UgC898kjzEjdplpFIwWbgz4J00LOdtyxUHTE93tjxKuaDOrmtopK0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 1:55=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> Implement `ForeignOwnable` for `Owned<T>`. This allows use of `Owned<T>` =
in
> places such as the `XArray`.
>
> Note that `T` does not need to implement `ForeignOwnable` for `Owned<T>` =
to
> implement `ForeignOwnable`.
>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> Reviewed-by: Gary Guo <gary@garyguo.net>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

