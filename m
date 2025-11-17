Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74719CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 20:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5F78E000A; Mon, 17 Nov 2025 15:08:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9861A8E0002; Mon, 17 Nov 2025 15:08:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875398E000A; Mon, 17 Nov 2025 15:08:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72CB78E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:08:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 252DD160285
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:08:47 +0000 (UTC)
X-FDA: 84121187094.09.F9C2115
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id 35319140008
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:08:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="D/hpOXUe";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763410125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8IeajO+LKfiTWjgb9/LynkoZi0BDB3SfDWMQAsNP9Q=;
	b=vyBi1SLW0FSoGGnmMQUc2sZiiJbu9dLTsIUpmM/2ion5Rw3SpTlQdYTuiDAEmx7n4RCaMl
	89pQ8MpJSeSX+yb3WwfodnVeXtqzQUekyICGP/2naRHxE5X1WOSGaVzmGomgFUJKxmz2Ji
	XHf2QQ8QnoQf46SBqHQ4ciFWndUPcpE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763410125; a=rsa-sha256;
	cv=none;
	b=Lab/uP/Y1V1h/SkwRhu5S9Mt6o63G4qMd1GqQXzghHGQRHvmZiicMoSyjslnNxroIxS0QS
	ZoorvkegClFxnelylLdKj7RGpQ+AcjjTrrQhywtME2Nc+BjKuVZDJGKI3FbKA2T5dnAzEQ
	4v05TX8gbEOOW10TLbznfdKpipsg1L0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="D/hpOXUe";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5942bac322dso4456638e87.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763410123; x=1764014923; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B8IeajO+LKfiTWjgb9/LynkoZi0BDB3SfDWMQAsNP9Q=;
        b=D/hpOXUemaThHQZOMGrUuv12tG1W7WS90YvVYsDgBp74b9TPo77zrbK0JDil7dHsFd
         PHE2shm2KKoUqpWobXZDTaVI2eFw5cxZ+IFaqvL8sw7BHp+L2QvbaTSGu29c8bZHgx4t
         EVDQox8aBrOSp5glSKINqse/H0UhlbsKIu+0MjweFIefoaufg12gZ77vsqQove4ojpzs
         aKINA0pVWB8PIGv0cZdsg2G0zgNgXS234HLXpWSaaERt3QSxTr/jali8tns2WIrh7ac9
         c3YBjEduZXdBpxVhkcskGdPeGlUyUGmUHeidTzQCq7+lTmgUfOSjUpFqBvLDENsA2k13
         M6bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763410123; x=1764014923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B8IeajO+LKfiTWjgb9/LynkoZi0BDB3SfDWMQAsNP9Q=;
        b=HibVkFce7HqCd069UDYe+3DiKzo63cZDfpb5zDYbXAIkiBC2VPRhMP0myzF47C9TQF
         rWRLe4LF24/wFNkDgJ6kwaIsHFV4x9n3JA182J0JPYob298y/qxYU7El96jJz7mie4JQ
         X7KFJaIE/1Kb2mYBlMw+MTRdyRRbx/ibRTTsASs3+0fCUEupbuHd3eFUh00GPjtcFxpw
         XdNJELikvc/3g6pmk6lD+rS2PNAoEDBZLhH2R0SFbSPusspyZDW5ujYSrQSOUme+RThe
         jRj9l35RF5uDAMAwhiwRhGi4G9wVpidcdXUUaAAgpRpcHo4WrFf7cpJKZ6hiPjlf61An
         Nsug==
X-Forwarded-Encrypted: i=1; AJvYcCUO5HD2McXGR60sqXyizpZ+g1QRPBhmB3+sMy1DPuOUhbMmbKJC4QBbbSl7XlSi4l/OyjfZiydL8g==@kvack.org
X-Gm-Message-State: AOJu0YwYo9VOJiI15kSEWgtupmvbZcJrVfvvu0bg/zqsz+xfPYWNJno9
	jF5+CcfvLmXz5hLFw2E4EapC13set8xvBucDcTgoJOnlhquPLzTcwDXl5YEqGR0KuAzWKAeMhYR
	igk0C8qC0Vc8bJ9urzWjWfSn5hLdr8nbkB6xFIIrZ
X-Gm-Gg: ASbGnct4+B/skVVpSbrH4VzZpsv1L4toO6dV0TVgsohq/NlbjHDB1wwEhHs2oLcqfWH
	HkL22woav4ExW0kPUQtsO/OmaCXwk1c309QH148CT/bxhBH1RC9PCkbGSs7sFjqaa7G0c1JY5V3
	OCQn2NTVx5ZL1Nr0toUt8/Sm6k6iMgDpX6hjYUksXjHx67OLU4gmTAcUy1DjtInmp/LXI7UXz+n
	UWJx3L+Jqs5kPhO/Ok867LgIBmVZlJBMpFXJdBNLgfW0vO4ml8sQR+vg51DkJGCi5q7ufrXBMJJ
	6fedtRjICYB4vIwG
X-Google-Smtp-Source: AGHT+IHojPwd3v72NJVpkRmb3ZkvRiR6CtkdMhnImHWMeD919h0DtLK7G2dHr+aPFZd7TlllVFDo3XPzHq7+z0cC59I=
X-Received: by 2002:a05:6512:b17:b0:594:27c6:a03 with SMTP id
 2adb3069b0e04-595841af94fmr4509003e87.13.1763410122875; Mon, 17 Nov 2025
 12:08:42 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-19-pasha.tatashin@soleen.com> <CALzav=edxTsa7uO7XxiUSx+DZiX169T4WL39vYsn3_WcUuVKrg@mail.gmail.com>
In-Reply-To: <CALzav=edxTsa7uO7XxiUSx+DZiX169T4WL39vYsn3_WcUuVKrg@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 17 Nov 2025 12:08:14 -0800
X-Gm-Features: AWmQ_bn0yHZxh94v8VlTzlMn4GZr7M3WPHVUsDMCpZs3Y3uXKCxbVDFrAaiWm-s
Message-ID: <CALzav=f+6hQ-UYBpwmAyKHPmtvEq-Q=mOL20_rZmAcTyd87+Vg@mail.gmail.com>
Subject: Re: [PATCH v6 18/20] selftests/liveupdate: Add kexec-based selftest
 for session lifecycle
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hiq8tsmutw7t8t8pofsfjoi7kiaowgc4
X-Rspam-User: 
X-Rspamd-Queue-Id: 35319140008
X-Rspamd-Server: rspam10
X-HE-Tag: 1763410124-951079
X-HE-Meta: U2FsdGVkX19FlLZQECg7bg4aneic+v3wJ0X0Xiez6rDyQcGndcyDwFXfXxm22D+4o6Fr8jyvoadSDTjuA1vVKTn8htKoyY1ExRuc2xYkWFU87tiP5KobuEKQpHz/JhmmpSJJhCGuPd/+vIJszwU4yi2GyWBZvf0cj7G6RSH2sgSXQj0O1TolWr1K2dstZSXew8V/RlrddAt24O5J+NSrcXAWxJbuGu4qgUYRQi7KpnKOjro1ba4dQGdd6TpiVHr0jlp39UNB2flB35bSvCrxaK4E2kRpd/Twwmd6xZypRAWgZf+EgWW9EoEEkVvgoEDwV9JxMXgkxOxMVs2fFqNIE8mpomPOukye/GBKfswvYZjq/DTC6YQ0OMmzbNlbBvKmuie6Q4j9JbUi+e7Bp4JoHg+ZUi4TxHNs307MvSw1MawZ/cfrXL9PvLEwLQWP2QvnJMdbbtb4dvfmzdZulydmRKxGgKhBzSUVqOvzXf2+tjSkNjdgMBIvmfeiFiBtwuUNK5Vcvtdl+XguZbVNDpwZGMZoorLNWmiUGwAVbRnpX2tx2QAYTlRslohegwI2N8CbYWFdDQ3PBD2fnkdg/IHpZqyXXw8JNwWC1vUvMfPrCIDgM1zhF/dLR+p12B+gVmXPfU6UqTSofV0IoEOiVN6n7HW1Jf9qv1Dim38BA2mbzfPZnG6+JVxjA/TwD+3yB1qPl1s+470H7daYW9X2Rq7A9KjeVQplillgpQFSyvGr+N91T0FYsCC+rSxGO6lniI1zYwc3bd9Sa/o1qeFOx+0JIOlRmLPb1XZTFjFqI7IaeBr2o8DdgGNxDWrJXwVDn3yBGYP2xQrveR8HIvyqxgtKEKOOv0rS8a+eQfrgubiEnEPwx+WBUXyelgH7SdU5PL2b6IwfbEiNGvXNIjwArB6baeeazcLmboLwJElGg/XvmYmr5JotPjxwVpoXvofsTLPf+up7/MT0sgTTGL7FHt3
 59dHCvEI
 yL+tEpb1UmdsTh+xPTyCLvB5zfi1rksKbqpd5ZexGVMBw9sdhsT5VeXeA5wIMiDiVMSU+gzNXhXUCg1ELi+I5ZcCyKVn0kKgthOUF5PLnnx/gRipb0NUSTjEzjBEVCIUJPjeUjj8nnZ1JKFQT8K7IanKIbw2wbiUvJ1fulCn4rzvmBzjH1tboP5rY5mEWpsiRG9XzqRlep37m7Or0ad/7KbD738zaQMOs+R1hos7zwmKydfuCIJjwMATIZihQh114LbASZx037RCBvF1vGaCKUbNXphRFbnJ/CQiU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 11:27=E2=80=AFAM David Matlack <dmatlack@google.com=
> wrote:

> Putting it all together, here is what I'd recommend for this Makefile
> (drop-in replacement for the current Makefile). This will also make it
> easier for me to share the library code with VFIO selftests, which
> I'll need to do in the VFIO series.
>
> (Sorry in advance for the line wrap. I had to send this through gmail.)

Oops I dropped the build rule for liveupdate.c. Here it is with that includ=
ed:

# SPDX-License-Identifier: GPL-2.0-only

LIBLIVEUPDATE_C +=3D luo_test_utils.c

TEST_GEN_PROGS +=3D liveupdate
TEST_GEN_PROGS_EXTENDED +=3D luo_kexec_simple
TEST_GEN_PROGS_EXTENDED +=3D luo_multi_session

TEST_FILES +=3D do_kexec.sh

include ../lib.mk

CFLAGS +=3D $(KHDR_INCLUDES)
CFLAGS +=3D -Wall -O2 -Wno-unused-function
CFLAGS +=3D -MD
CFLAGS +=3D $(EXTRA_CFLAGS)

LIBLIVEUPDATE_O :=3D $(patsubst %.c, $(OUTPUT)/%.o, $(LIBLIVEUPDATE_C))
TEST_PROGS :=3D $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED)
TEST_PROGS_O :=3D $(patsubst %, %.o, $(TEST_PROGS))

TEST_DEP_FILES +=3D $(patsubst %.o, %.d, $(LIBLIVEUPDATE_O))
TEST_DEP_FILES +=3D $(patsubst %.o, %.d, $(TEST_PROGS_O))
-include $(TEST_DEP_FILES)

$(LIBLIVEUPDATE_O): $(OUTPUT)/%.o: %.c
        $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@

$(TEST_PROGS): %: %.o $(LIBLIVEUPDATE_O)
        $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $<
$(LIBLIVEUPDATE_O) $(LDLIBS) -o $@

EXTRA_CLEAN +=3D $(LIBLIVEUPDATE_O)
EXTRA_CLEAN +=3D $(TEST_PROGS_O)
EXTRA_CLEAN +=3D $(TEST_DEP_FILES)

