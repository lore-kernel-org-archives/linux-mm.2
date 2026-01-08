Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B1A0D1489D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 03:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448B76B0092; Wed,  7 Jan 2026 22:57:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420E96B0093; Wed,  7 Jan 2026 22:57:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5CE6B0095; Wed,  7 Jan 2026 22:57:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 203E96B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:57:45 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BEC101AB0ED
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:57:44 +0000 (UTC)
X-FDA: 84307437648.08.A40C8CA
Received: from mail-qt1-f196.google.com (mail-qt1-f196.google.com [209.85.160.196])
	by imf13.hostedemail.com (Postfix) with ESMTP id E80CC20003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:57:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BhFzDsIS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.160.196 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767844662; a=rsa-sha256;
	cv=none;
	b=UAQfG+jv+81w6+i38a3vsFdXH47eeL8I5igijRPncAizaDGi7b6uXBXcRwoVhbZUTa6qzB
	PSU0zuc/P+zDCaJ9JaCgESLnMqj51MFafWocMfHKsar3e6s9YfUSBysk/y4UXF25herAGw
	otuzmpz2f3ZGDFUcErxJRn/FImnzZqI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BhFzDsIS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.160.196 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767844662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OSwdeu7tKlsfiSUj4eNrRufNOD7Vq/gThbg2+UQyNgA=;
	b=PbUp21jB4+lak+1soHiKfWDw/zxIaG1cLXcjYKvMY2UcWrfNYVBewAMjcbND6T/cgJ0cg3
	ZC5ewSWee8zgAMAgbZAfcVfDLSl4ITZSmfE4dMvrfHuiXZNhUWezG/UR61nABSUKWAvJ6o
	A9Lju8VbOnShlV7Z6lE/TVKLOGejh5s=
Received: by mail-qt1-f196.google.com with SMTP id d75a77b69052e-4f1aecac2c9so18378521cf.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 19:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767844662; x=1768449462; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OSwdeu7tKlsfiSUj4eNrRufNOD7Vq/gThbg2+UQyNgA=;
        b=BhFzDsISH5WM4cL07Ni2LEJmhTaMR+G2BtyOZQyE+/8+EORI4gVk7Xln2m4fFkCpQe
         eY50Gh5e6AOIszjGiPNy3vTfacbzazUpiVMkXovSahFhbkrN3FY6DfVbvoFg1CedQWJ8
         T3NeRxiE5rwgqp0o9efvi1U3oSCGSYg7z5dNQFmaeRKwFR+jan1icw5CsRCP9pZkloIu
         cZmYsaE7fEdi+k8fwNZBP/pRNhCZwMMIiKVyvHgilNUNyQ8yDvskXszzX7/rNzjImnwI
         pwoX5TAEG04jRr77FqODp/wOeqx8zgvgAm8nmhar4OdRZHZKoPmVDsJsO4/SUKZaMfly
         zPZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767844662; x=1768449462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OSwdeu7tKlsfiSUj4eNrRufNOD7Vq/gThbg2+UQyNgA=;
        b=IWcknju9HwrA6Hi+xd64z4Eyjfz2J3sQ2hnOl2NREIzbqvUb9p7HtRrbMW2DQYZZdG
         g3bRhVJN70vrnklxr/cTxGghvRs944LsHgwWVM1yayNXMa1Gpt26z2OTfpkY0TDooLSG
         JFQB1GR9OqzeKn+9oo5ZwFzX9P5URS1jE/lqBYNdIRlFias9/u2mpLGWoq/Os+FdveEi
         0kvFuJXKsEFPKWtUhtPoDuh753JwFY3LSsyFeUDT8EAOWrlPO6jT3oass7Q/6BA/1TvQ
         iAgU02MUPPFaCcCtlRi6JGVHskpecJmsJWKoRHPFj3BDd7qQxt6D3PoybKyqDVXjhEw+
         oJzQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1aDbjH+cjUoiTDyedOUweUJY5Flwu3f79rGqIK4FkAojPFWtdU0RYQTGl1zZN2Y2MqcAHdGhGQQ==@kvack.org
X-Gm-Message-State: AOJu0YyQRjd2KkT0tKUaO8Foh4A9O1aL4hHeWBFW1RpktWk/qBJJwylr
	nVfXrc1rNdgMJ759T5795mhQRmwWQQTuzFgkzO7z7SM7MuNvWFUJtsXvr+YWZhgOmBQ=
X-Gm-Gg: AY/fxX7q8e9EHCn+ruYk6bnagSZ/DWddUwwS+TB60jgL3XxoN/xGE2UuKibYVbxwcB2
	gIqq6O5S0xnOjb6dNT23srBK7f2lw++e9xVwaWbIriT9gibndll2hvWeAHr54CKVT+Bhn8MgXeK
	6ZYLL2GN7M/E2MyLHbgcCOpMaRqUJs8EeI3lh9/FAzRNoR5RY7IQp2HeX+ojAQ/x0NsSDDfiamP
	XlS9Zls0ZE4SWesVAIOTtbi2qSoFGqSTDCKBgo5qNo1jhQ4CSOiLFQ0rec4R/c2/4pSgsEPk6/1
	ZN90hiRX/aecyvHjDPJjbRryN3DsB7AT11RzGIHCo0Jo1nVGZ6orARLfr9funZwf4f1/rOhaswF
	b5Y+WDZ0iGM2t0bwk/tU/N76K2OyCwf4nWg4g9nOr86Dp0jul/XldzPYKBToi58DiaSIvsCrcZF
	VWfTerd3yRrI02GkW1MDumpOefG8IZXP05BDu85w==
X-Google-Smtp-Source: AGHT+IGC5R+X+FreQrDYdBHuWpgbcu1uan6wSmhYD2wGNBDN/J5foNH8mP3Ir8fpbd59JOEyhj1FwQ==
X-Received: by 2002:a17:903:acc:b0:295:134:9ae5 with SMTP id d9443c01a7336-2a3edb8bf35mr40737235ad.24.1767838531386;
        Wed, 07 Jan 2026 18:15:31 -0800 (PST)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.217])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cd4be5sm62404195ad.99.2026.01.07.18.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 18:15:30 -0800 (PST)
From: Qing Wang <wangqing7171@gmail.com>
To: kees@kernel.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	bsegall@google.com,
	david@kernel.org,
	dietmar.eggemann@arm.com,
	juri.lelli@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mgorman@suse.de,
	mhocko@suse.com,
	mingo@redhat.com,
	peterz@infradead.org,
	rostedt@goodmis.org,
	rppt@kernel.org,
	surenb@google.com,
	syzbot+e0378d4f4fe57aa2bdd0@syzkaller.appspotmail.com,
	vbabka@suse.cz,
	vincent.guittot@linaro.org,
	vschneid@redhat.com,
	wangqing7171@gmail.com
Subject: Re: [PATCH] fork/pid: Fix use-after-free in __task_pid_nr_ns
Date: Thu,  8 Jan 2026 10:15:21 +0800
Message-Id: <20260108021521.3838492-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <202601071238.F86C2B8@keescook>
References: <202601071238.F86C2B8@keescook>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E80CC20003
X-Rspamd-Server: rspam10
X-Stat-Signature: w1zgeast3kui1eyu56k1cttxi7w6ns6e
X-HE-Tag: 1767844662-657952
X-HE-Meta: U2FsdGVkX19Fpd4NlCxlFhRNnfgm5pJ7vHNQbjoB/1WfvgqnBhflejb5QeRVVtlv4R4n5WFw7tttDtijpqI5f9q/yfVBskc90qLxXAGCAZTAVHyI82hKJcpG8inehzGQ7N9CRwr3A0y9lYIo6F6hppjsl1sN/E2v3cUKfUuPBoY5ET8291/OkF/Wg3yKzx6/cj7omeyQA0fcFgCxiVYY/LVD6p059L1L4yOiYjHfCXErOztQEMQIuOdGWcShNKJIEUK6pW/lxiIR1jSgT0G14HbmMKiucKTIoNOx/Bvhoctk86KbciSe3eKdyLEslNmuwGpO+ky8RQMIy4IMdc3MPMeLQLs7yYoldzXZSWrOifhnl/aLc8n7b0ECdPVOAeygIbL1qb0MxeL7QQwuejxIqZ0YB1mkTfEdNylA1p17d7JwPULUsZK/Ymge6/FxvV6WhPPmn0nRL/OfIc4nAttM0u/Dkh0kSWGIKd6vJeilFZEx2fGRQ2tzp65QXwyL1AUFrAs9DJ9oc9Dah6alI6v8nhcQ9vtLUZFTLJNyOFO8+xfz9SMrsIFfkdaj/BQ50bt+CvfIkp7H0BZDWncQNQqlEd/SoHVdvMSwuUEZtzMvZvMNXzruX4FGgFgVH12q/qNJGUkUdIylCCZmG95yuZPL94DS77BueoxAhRKaifYpK4V6LNxlOZZiOZEQc+bUt2whP68s0XXdejlyhyehCJRuoATnllN1IOh8oaNubThNoH0Xyi6n8tSodykORiSCAIb5er86YBTtX95IuVbsnsI4bBP5XUWlPcM5w08jRDUfE0xfs5mD1VFBuU1CdydNXmzzhljEZfqPEP7xNoyCCdwANuAsXZwjowvir4AGijmD+x4U9YlQqOPfDXarpNiO/YDqYTlLtzrCsqQW57wEkMUdAhEmaogT4kxXZtHiT3yK3XSDHx8OUCM8tlvJHe5jV1Gz6h3rfsoeu7V9N9GCghb
 +14uy2j9
 HapuubaZAbpRHZwcJGQJWOL5IvoSOK4CKjnbTZmulp6EjMoG8Cr68Oe9zojs5rYxh5H25+nkyzWQXKFhRkfG1eg0rGTiu4iMROI+fadIovHt6SqZVvreoiMZYELtJnpEx8Avzb87JDuOK7y9T6tu5c5RWyahaFSo5/DiGfTxuDVXJIxn0raS4Ov50VXUG78RZITfxQo6k+q3I/e4x4UlSSTv98nAQFNdxOwO3xCEaHlM+lWJLW8yb5wMTrckwpqItEcTF/+HFWnGliHRgaNgsmV00FKTnFsFMthAKr6H+1/SIqzYrHYOyjaO8incys5uqcR+XSBSPNLfT07YlcrrMjOU0RT4PW1dR3g0/lvEkbX2r7cVNpO5L2vNm00Db6qenihq4P1X9DKkCm2xP0AKeeluJJcBqWDb5VfS909SdaWXY820lp/0vHHWAfaxVN0d0srIu9rA7khAxWJ27VIfc4FVBTSQIhSvO5BAtiUeb8WwoxUxgnVbwBmHvpHCROCvIBFi4ZV9jzM09deOaK413GTHL/uYf98enNmgli68d4KnWTJMh6yJ8A6kMVcL3jotSZnZbNDWhsgjunFxr17GER5lZQzEcp3I+qfeWXD7h1prCZaFEYSZ+vS3RlEV2Cxah9YNcClJljNSYQej4Pu73KhXmDVtiyd5N46UvyQkswzhZo44lB+uGoTcDS7TXMWRezzDV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.199068, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 08 Jan 2026 at 04:39, Kees Cook <kees@kernel.org> wrote:
> It seems like there is synchronization missing between the task->signal
> assignment and its check in task_pid_ptr? Aren't there other ways of
> checking if a task is dead? This change doesn't look right to me...
> 
> -Kees

Thanks for your reply. Oleg and I discussed this and concluded that this
issue no longer exists.

Discussion: https://lore.kernel.org/all/aV5zkjzLTwKQOn9D@redhat.com/#R

Qing.

