Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD132606A321
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 15:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=gST2NHJh
Received: by kanga.kvack.org (Postfix)
	id BD1C96B05B3; Sun,  8 Nov 2026 10:24:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B833A6B05B4; Sun,  8 Nov 2026 10:24:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D57B6B05B5; Sun,  8 Nov 2026 10:24:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5617A6B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 10:24:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BEE521A046A
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:24:26 +0000 (UTC)
X-FDA: 85412323332.04.82E5A81
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id C5EA8100008
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:24:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gST2NHJh;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794151464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxG7GXUsicfCIDfMFjBbx3umG5dZ58gNRJ1FSEEffBI=;
	b=NPinl6OOyjHBRKIWeSaNiOJyYhjoyGxs1FFaFzCadwoVkpXwt/0r0J/dITo/vTnEBfzLgT
	d1IRcoxkHisy6WgjsIViJ1BQ4zxm9QZSNloR9s6bxW/nySHNvo9o1dkajuTQv8e2Mzf/1m
	WM8KYF+GbUDj04bUWRMGqgMj1EnApp4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gST2NHJh;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794151464;
	b=1j1aAWTerKQD2KYtWVKZ4+dV+XgrDMbnOVj46mByeS6BJA3u3flxl+UVngWKrol9iMa9bQ
	k6FG6LNuepDeONPLTHqh6qUBZFI0ypAzB4v4n+nNmIPRL3rlGCBbKqCJCz47qdJPpqEGQ9
	dOj83kwKADsEGrquOoRFlosvyqKm7P0=
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5eafaeb8684so31387e0c.3
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 07:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794151464; x=1794756264; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UxG7GXUsicfCIDfMFjBbx3umG5dZ58gNRJ1FSEEffBI=;
        b=gST2NHJhKwUxUzll9qoW/A5yV4Pw3YU393AlpCbmID0Y1cnm2yO7k9mdF6xHklBpgt
         JG0eCgroTsfqnxOrEXZqilae9NsPoXryJA9jiTpdyDpN1zj4Jiub1fsrYeTGRMACIWwe
         /Al3xVvLpyk8lZhGAMb1N58tve8Vn/Nmjk78kppkyLqAz27Vgfd336EN8hjgTHCNPEgZ
         ln0nAL4qFlVV+dO6A1Hg+CBi9lRNJzeoDGudglnB177SqYGHI9tRKyZ+WiD4dtaZCcpK
         wRZNdKRIOdBUJE4RldBaN9wUcg96JzC1J2ByJgZhbtFVVCJekrrUjJLdt56J4MZho/Li
         6XAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794151464; x=1794756264;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UxG7GXUsicfCIDfMFjBbx3umG5dZ58gNRJ1FSEEffBI=;
        b=so/pZ9yzamTz4yM2B/j1yInNeGz5V2ictxcyulHwuCY+dZAwU/z5q6q2fCjjToSavM
         YNmjMI04he8TlwTUFWRuVuF/6REi6QTx3CMirECgsC8SACFUHRwJtaK/KwXfZiNCVoqq
         ZDpeS113CrpBppCO85PO/UsumtfF7+BtnwGdWJljrqrKLSewEpVV6+/iJjC4kAV17GWg
         cBYQ4uEDTSbYGuCcfQOFK24wVKHEgHqE/D4Ybc+vJ6RKu9Z5oYrfUYir3Ah8sIg+F6kt
         BJS+42RUC5A8tOJR4KEj4f6AINfgoJlQBI7XmGzOo7+sCLRcA0+AsSNF0tCKdaudAD8L
         9KuA==
X-Forwarded-Encrypted: i=1; AL+hErGibAvshwMNk1Qb2mFwY5aqSld3Ad3SZjtPVsK1MIH/eKC83jQzyxSh8hPPthS9qzF51meQHmrZsA==@kvack.org
X-Gm-Message-State: APuU4Z/wsofdVZZRR2h5fCxvfyno3d7GtKtiuTGHQUtqBvtWH6i8QXw/
	IBCF5dmFFcWi23LXOS2k7h7RaJg0t5cpTPPsJFqfCrojaH9jse0tX3ScNhPcrjzTngE=
X-Gm-Gg: AYBFou2P6+7D6kx2eaouJLubARFhfV6LNxj/kSA+hJoIegTSfBgbYFP0YOeawnNgyPp
	QqgHpaMx0xoQh6jdTcNd4dlSN/4tL9gmPQalg0urfPNp6JtrpQbwTBGB0c4jIDBMDUxxHowqqKP
	kz3HA22Lv0Co0PP7qGgDbvsRqbJfkOdi06HLMldEnfr40q/hKgGOYXQUOtxuWNobDtvESMeQ3yO
	Gfhrbchf9o/StGQO7zWM8hJTm2gmYbZ23RzkaZxJmrthcOBzHzLG2Qd1W5eTJMz9OOLtfW92QzR
	/P3PtqpxE+/XWjwooIz6l9BMn+QfUs3qh+ZcEumYXmNwUgqU5MiZcZ2J2/dnrr54qOzGctV9CH3
	qHDFNnlS59jEKUNJwCfwaU7gVkBZnuKZzh/MYRJs4sYYz00JMbIfI7Z8DQmUpEe7q/GGPH2wPbT
	6vFWybBhuagRCl4K4TSPTG7dH15W9NxM8k/LaPlfuHsJ6MSdKg7cmTk+ZQaE9HBx3HvGMuZqevF
	e0Gr8xd1sAId61HqjjoY9B2i31rEezYuuv5xf0cLb/q28aOxQ/SzcSbj+YEsBggDbSjieuIWrzv
	FI5yhicVmD3YQrHn7Pm9wSUhCocpc5HomGtLe9qiOYov9AYxfQVf2mNyxy/EYyU49NWN1E5f2nj
	aTFDeaW7lMxFcckhBsYq2Qvx9aK/Z8JQo8esPcZqT5A5smss=
X-Received: by 2002:a05:6122:546:b0:5ea:389c:51fe with SMTP id 71dfb90a1353d-5ece725fcc1mr534957e0c.17.1794151463870;
        Sun, 08 Nov 2026 07:24:23 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ece60c1adfsm2166205e0c.8.2026.11.08.07.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 07:24:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 4/4] selftests: liveupdate: Add riscv support
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Chen Pei <cp0613@linux.alibaba.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, alex@ghiti.fr, rppt@kernel.org, 
 pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com, 
 shuah@kernel.org, guoren@kernel.org, linux-riscv@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, kexec@lists.infradead.org
In-Reply-To: <20261106071459.2003-5-cp0613@linux.alibaba.com>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com>
 <20261106071459.2003-5-cp0613@linux.alibaba.com>
Date: Sun, 08 Nov 2026 10:24:13 -0500
Message-Id: <179415145359.358073.275309518363721943.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=417;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=FtmrOogkqyUZ+q/8/Vic7Il7P35EARJys1IQgDvRVIs=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq8JQhVEhYRlNImO2ueIVy23Pfe/4w2LJsKj2WG
 qH/Tmd7+XeJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCavCUIQAKCRC7dyhM23N6
 3vP+D/sGPpbNDhlfiFA68lnaSlf3Ud1W6sEIzkODc2Rr/nh/XGhE/+iIjOkpoSCxRJE/NO9C+DG
 jRVkLElYMybWKAUMrMtK/FIY/Mmj3rQk8/+k2K6EyT8bp5Y5pm3UJWc3keXSIflkIzqBrdk8OXd
 jc5vEvhN6qdxqdjUra55/a8LMtN17XIqisUGChRTOKnezNh85HlE5QXwKBWEqOhTZjrKrntjYer
 eOUgHTCNquEbY7APFlbwpmVAwBwissclqIuP6RyhNBxnQRqOXacs8aiRer/a3lrBw56srBMgGEF
 Rz9b6ezMwvCKh5xpZJRAGlCpYcn4mztgSYF7qcsBmQdYhJq7h6bupQliFFODDM+BF8IPhTU0qYp
 JpCLkQvAUYKCSzApDXp4mGTNdwfPr+Dn/vL7vv21BiZ3nYC2zdmt8L3v34AoMkQuK+a0s1nUWMh
 syI3MknQ2599AHAVwKArwt3/21IjEzIIbZzcZdO+XsALXP79CbPrgN3Tz6Z+h1Dr8LB3dmfQTFm
 nhFIECmygvfqj7AVJQhQeN3IHyDJyyhpqLb3t7HlTEs4+MYEROzKSC+8ZZogWFtGCHVfovlcKgP
 uKerMtzV8HQ4ZSBMJ1ZQ5PX9EMGpc8uOa/dLCjDJX6tjUtcIEoU0vWb/7qtwlMVuPp0e1ny0g4M
 TnCpyQ6RyzM/VOw==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C5EA8100008
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: z7ifkxi7xxatekps7x7ccetaj8tfj987
X-HE-Tag: 1794151464-338678
X-HE-Meta: U2FsdGVkX18j1od+kVZDzsMfctMn+Y4YGeFL0n6Elv/oIKgIAcPIrNn/anlL4Gsa0oImOu11kdh7lWGHyofiWWbXiOYY9JtBqRK0F8IGBv0FGpIIgIkzErzTxzSUI2lat/4x0hnw2mxJBhWGheLkQ8/mCFK/h4vgPposFkjIxoSe1rK3nqBbplg8GKCu3+2thUZkrNVjkK7T/d43Dd+pJWy7g4AtyXfE0a8usPvCJaP/xRE4t1GtC3vchTu/cTNen9zjq+B5eRlc2VdQM0KV1A0FZzF+3q+uvchGLqsyhX+VYLq+dA1nfkyzx86YJ1wJJAln74OW0x6tMHW2oP4cgoPcr6nzmMkcauvJaiLXL05trfa1klUTQRrX2S7BTcJS16h4mXkIs4RmSl1q96LsO0cUPy/GDsuTgxIKBrVcu4OE/UmYH3KVsCfwOhqXK7u7/0t0hX7O6QfN2NY2a0A0jxqHQCo+IKZjFabw82vqNKFaww4UUZSP38NJ5z6u7NERe68lx6SJ9/O+cAKwxo/nzLe6nWmuJYKqBnmHu/798YF01uFJHtVb8e9Ehy83vpHrXwoJB+WnJk5DIpuNe1xh9m8cNwOqNYRoAaWKcnKloVIlUWwaaBYRTqkN/PRvbFq9g1DO+aQ9I4JLUIYtC6Qh+qt8/jIvvqS8hyH7FrDa26MOMcL3Dw+R/wD8Ydsrl5uk1hkk4BjnK8robWCjoK4KBYB80uhb4KQ9yY1xEFd6YRdhtGmWbkEJIYIIOKD/FRmfHiVEcqhoiyDBiOoWs1t423C55RftfCsgtZ1o5UuSS6+2IzioyNaVUJSmjjwdvnpMpEncYOtOzjWJL4J16waZIGPsUGNqPEmP+OJ1zs4CCWHy1frm9RZWruumHWcqvxa3V03KsKezIVQeUqne9gE5j3yA9hqtiwRHHWpuPWqDtOkRRZPdMh4kXNNidNjZ6B1Vk8MHlgxN2A+hx0XoNY4
 Q+u0aRd4
 FZ/Tp0KiGb9ybbKN1u745Uu1kdz/pKwbGnlE5KdyQI5oyQjDKTc8Z1Q2P3joxLQYEYpgZzaKjms+ivkFP7Va9a3YAp0qacze7i2dgB/qFS1hU1XeBLdPKDibuNgRJ9qXCrYXtrg68tloojCHjrRdpAs3oygPvrxz/jJq2Pnc6awzgTQ7YuHZLenfA1zqVsCE+nzop2iWb/Mieos963sOk3FchRzxhnhNP+uLpMgTkE/9W09XUufMaeYKIvDCdNVQhD1tgFxHLPonxaPjMzXAddKqWYmRev+swZT7Q14cC7Tax/OgY+VLXhaIHVKP7zBrHTUPh0ulxtsoIkw9htWuVfNC08CZ+mScXuR//1lrzdSa67bw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 06 Nov 2026 15:14:59 +0800, Chen Pei <cp0613@linux.alibaba.com> wrote:
> Teach the live update vmtest runners about riscv64, so the LUO tests can
> be run on this architecture.
> 
> LIVEUPDATE depends only on KEXEC_HANDOVER, enabled for riscv64 by the
> previous commit, so nothing in the tests stood in the way.
> 
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


