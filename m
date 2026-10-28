Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AD7A606A324
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=N510ahVu
Received: by kanga.kvack.org (Postfix)
	id A0E3C6B05B0; Wed, 28 Oct 2026 04:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BEC46B05B1; Wed, 28 Oct 2026 04:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AD3E6B05B2; Wed, 28 Oct 2026 04:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6422E6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:03:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3EBAA0C33
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:02:59 +0000 (UTC)
X-FDA: 85371294078.11.43DC555
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf31.hostedemail.com (Postfix) with ESMTP id C6B4720002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:02:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=N510ahVu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793174578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zFnsy/mob24c8UepWExGPAPqtimxDOCEXDMN+XTK9/U=;
	b=Gnncie/Z9dnFwAtp+Dw2Bs8tjhPxcH2H/SjYdMBLxn+EeOLeaLOp2YE3pPO61IbFV+rMv/
	nOPDRoEQtMGnipLQcDFaIYLS3O7sHHut6luA4TIyCwlmni2gewWUdVzk2OqjIZ9VWq/4mq
	TtKjEdV5FMF5epBinA4mW09CabZbbM8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=N510ahVu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793174578;
	b=SPczcJH1In8uiyayfEx10iFvZ4EbgANviQdXJIhxjOaREBcZIxypvBGOuVXsxuHaH27ghZ
	JSK2HEmGDBGt/vC1182V3PK7OFpVlnuRQ5b3mAvWie94tYYuEBTymkYFk+aNv7ujB9VQvR
	pDjWT8dHgn4WeNBzn+2FpJ8FLoQ7fTY=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c413dea9ca6so104128866b.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793174576; x=1793779376; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zFnsy/mob24c8UepWExGPAPqtimxDOCEXDMN+XTK9/U=;
        b=N510ahVuEDZFeIxle3q9lW4lB07+2LKyCYqyimxIx8g9VmKPE9RX5zbb2JXN6ZE6VU
         FdcKy7WrQCLfFMHbQrvSyx1x4pRc4HSz96WCw4zrmT4tw7udI0iaegiPRiA4Zka3ImF8
         PHY7O80XraJpcAzBrIcvOTUYie7cH0bL5MlJg3i0ralkX3VxfBQf/c38z065m6fp3C2o
         PCjHVVRz/HC6s2VAT+zHlj0DYZYtKoiT4l3izAx/epUNR2rC2Nqo6JYWeT7zO9hUndOq
         gzH0DGTrmK9KvPANZAzFra7x3L12GwzIkhy8ztB/9FBAVOyPr0ROnktx91MP2TlGacDK
         Jr+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793174576; x=1793779376;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zFnsy/mob24c8UepWExGPAPqtimxDOCEXDMN+XTK9/U=;
        b=oV/j8GSQLiXju5gJ4qeS/4ayjZnPuT852LlFnC+z1lMeuoanXxEGsxAQLvBlr3WsMh
         EWlNzJz5x/Z2gZnClcIwmzkGLCjQCcNzZami4LfB3eg+LidVBfYZl7/agav6yCPipQpW
         50gnIbjsADpplbjOy1UiBrKt8QDQ3m+cdP5fFYh0L7NVO8jDEmlDX+zKvk/+z/sJ9Ofv
         LJ9e7XOiw8QyRAcLmQYQRpBDeLnDArQt/1v+/VURPMEJdL7Wi91ZKHOP9Rk+CapoK5un
         8/+y9by/OoPKPnT8F/CfjPhJ+fuk3NK5HjE2CoT8tr1QbeS+yzkKLQqDqQIyprzwNmWZ
         iXjQ==
X-Gm-Message-State: AFq9FYL7wLUGt2uyJf3E8s6yk2erVsS6+9RkbjnmShMBD4IfPdVwPVe+
	Ca0EBybvTDnWHKXrB7l/Oajx0fQ1n/8wb0ktQjwl3UZTKAE/pm9fDsIeWvIEMth+3d8=
X-Gm-Gg: AYBFou0rOKcL74q3CYJCeohQpSiG/I2+BM9INSboQPJh8UC6KniSlKFOwi941wsZX0L
	KA0e4AeAbhPI6TBW6dKWlvikGnifUb3S1sL96UC+5cSHPu7hXC1aYPuzCUWevHdSW1guy+19YN1
	Ieh/1RoWSw+yKdUEOMY6o6nUlI5WNYXTlJU3BmWh5hqgp3jYxdAbCf1bI8FzsAiiY2nzqSbWgvU
	Oll+IOi3k8QklJC+HJ2VVEtwZKsRJ8ffZtRmjE7+S5hKmmxUUfFnFVyy0bO8IvkvXuakdBhdrRl
	AwQkrmwSgXb4bd1XuvD5JURcvf3E12D1QsBjQFBb/l0lS7b7EiC5i/w76pEVAISKB9jCnu+yCGY
	RzBowYjHeuD8AcRT3KVu9uG/RLoB27EUtm5lg0tDnG2hacJFqdwoBXbD5QOvHV48M5E8vW/5X8L
	GfYxylZDCRNg6VkImYE98Wpi+XNVH58TrEMkA+41EqWNUe5fNw3ziZvlA46w+w5xxjNL46wJag5
	19Sasm5wGq0F6jz1erahD7bWp6ST6kPmWziewz5ecsUj3421USHh53JExiPi6eOHyQ5iSgmUuSS
	m3FZMhFGZyyC4sG9GL6wN5YOnvCRtALjW0kS83FRDqxVpw==
X-Received: by 2002:a17:906:7312:b0:c41:4964:90b6 with SMTP id a640c23a62f3a-c49bdf7af57mr116720166b.36.1793174576323;
        Wed, 28 Oct 2026 01:02:56 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecde7c3sm28580793f8f.51.2026.10.28.01.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 01:02:55 -0700 (PDT)
Message-ID: <21031961-def4-4244-b5c4-0ed0830beadf@gmail.com>
Date: Wed, 28 Oct 2026 09:02:54 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] selftests/mm: track the modules run_vmtests.sh
 loads
To: Qiliang Yuan <odys.yuan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261017-bug-selftests-mm-run-vmtests-xfs-modprobe-v2-0-cbb36b014322@gmail.com>
 <20261017-bug-selftests-mm-run-vmtests-xfs-modprobe-v2-1-cbb36b014322@gmail.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261017-bug-selftests-mm-run-vmtests-xfs-modprobe-v2-1-cbb36b014322@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C6B4720002
X-Stat-Signature: fymj9nq5mknphhusqqwn38ehcbdtzstw
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793174578-851343
X-HE-Meta: U2FsdGVkX1/JbZbaRA0RuCVy6Ku9IebNKO9gf66y89nU/pEK6DzM4nFbaTpXasCMlf+uD2WCbXpIt4bjn+dh8e8u8U4JH8VTwyNUY5W2SaI7D4duA+HN8DQD1HctNyQOexfwHp+4FFDlx3V+NWyO0mHUUvi39Z7P+leWMj6idkScnsznjaBU4dBMZ3uofbqFcI7aQEDgcLwSTYKMT1WGDaEWO2IlLi3rbmuTbA4t42hg0X/lvUzWePmheN/jPcHBsTiKQmwaeNuTxhfy34otbCvNYIVaLlDdwzbbKbAJaerxpiF3pWs++ZBxzdf49xYFFsWcuFrwTpb1gn/mve3kv+cSsPFWUpeKqz2P0FjzpC9FBCL+NeDMn52sli/Xj7o/owfqaq6LdVEgmdUawF78ZnHSiPgd9TIVM9/6benxfkjjHnpMj8pks5QehVlwiFsgZsNKcn4i9nCJsdh+B3ntAQGnAawAnUxlhXmFLAPjbpfMuGGmjaXQ7kk4RjNBr77xHlJfwnAtXq9gJ6ipKJd8bR0NLNdxC5Pdm32Rcf312YpvCqHijR2GgKT9up/MUrVIKQPDkJcWNtrhWOxd65Pj6gj4RfFEcNyGgAI42YgXFXWOGxiZrpn6Q7l0OPKXYMHmWuRNLx6Rc1533nM51A09GTBubSuXD8N4dudXrN3XAheJzFcQQN/fEcihiUR43K+L3U6bGcfVqKhkrsICiseEKDhP6iftBpD3uRq2pu9PCEEqCN8CYXeTWE855Nx4e/mmm/BjgOHsEc3JNjCrQqyUo5fgO+H/s3ZEuyC6uS8yEeVD5RJfhMtZ8s9arSzBbEbbcDC/upCgz24gPTafV+ALlz0AHQt/kLfYbSj3Bm4B4VmtDF63wnGiMh1HJTnzQKVEPmX5IAqUty/byjD9L1ArFVg8HxJ57lFBJSMVBjyYIJyuPaO5Gy3J2FB92SMetFVTPwwzJjEf/i4NuCjmbtN
 qvT1v9Lh
 eiELED2u/ljOJaGT/CEe0Ekz5j0BjL/4leN0JB7xuxXaAOT4iLJn559Vv5iyRDYJtOXB9bfN30JTDoHA47VtRgNj14TSj+pqjc+2lVDUHNqFl32qI1KBpEBGFr6ZCiyf2dKGm7kKUQOLHpDEeHIZ+jexrC5riKXxYMpxMGV3BDl5+iRn1VkxmigsthvhYmpvz8h+V92uWiOG1pKqAs/5f2v0BcWeE+uA3k0jaBYaaXpFCVE1rDi77S4ZJrv5FS3qEhctNWhKumujqRIav7+8tUI7WbsLdbkQnH6H8SSeVQztVAuF8rNjbwoqNqX7usXsT9bsTvL9mHiqxSUsyaHC18/l71xotLnUy0Ro+L704STNqSZfM2kxlC+pPp2KngWSCrHpO99IPK2JEpmOYEohaU6Ya8NY8hiFifb4pHqR9uLEjKT6+DmIH8mgC6bQ+MzH1pSirj3XLRaweBFcuFkYLZiLmImdbemdsmZid4cmHXbkQvdRV/ytAt30aXfesheyqyHSDOWyC3PSrut+yOAZFgv1F1OdWWeA0prmb7+aBUXV2JV/d9aIia+HVWbA4mO7XuveyTLGXA/tzVRI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/17/26 5:07 PM, Qiliang Yuan wrote:

[snip]

> +# Usage: load_module [module]
> +load_module() {
> +	if [ -d "/sys/module/$1" ]; then
> +		return 0
> +	fi


nice, this also stops it from unloading a hwpoison_inject it didn't load.

tested it on x86_64 in qemu with lockdep and DEBUG_VM, with
hwpoison_inject as a module. LGTM so:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

