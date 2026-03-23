Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E476F483DD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4BC16B0096; Mon, 23 Mar 2026 14:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFCF66B0098; Mon, 23 Mar 2026 14:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DBB6B009D; Mon, 23 Mar 2026 14:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86F2D6B0096
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:00:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F6DE5C72C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:00:50 +0000 (UTC)
X-FDA: 84578093460.16.881C15E
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1BE821C001F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:00:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TbfMm1TZ;
	spf=pass (imf18.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774288848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhS8A80UKHVBBONMyyB3JNJOZLsQWUQ/neWlg69pPXo=;
	b=bIuT2PfZRshKT2KGfMrqF+H9Mk/uvBN8tDzSne9wrO97IA/Nbfvzr8Dky8jLaqN0GYzn9a
	lBoP89MPzoiJxUL1Tlika874JKwaQmfgpL1QjrlIc3rT6ZS+7b5Z2OWc6dI/k6l+eKjLP+
	JNARMuwmcBzazjj/aXuHe2hiODQmqmY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TbfMm1TZ;
	spf=pass (imf18.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774288848; a=rsa-sha256;
	cv=pass;
	b=PZmhQdeVVBkV3iHpm4ntfPGXlFHufhdIStn7zhOunBkrvoF7BYS3H+QaBXRgtOKfeHuYea
	Bb9VwD0CX7xdACe4AzAFsxjitp2q9Sz0MIHrYuElOez/BHi6mMQDlNjs3dPJyqJ+gUWh7x
	0oi4zW9E/7Q2SSvAlK2OWqVWAOsLaBo=
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-5fff77ff719so292163137.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:00:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774288847; cv=none;
        d=google.com; s=arc-20240605;
        b=CZ0wvPyxp1+n2B9fOvUCJpTg29fXmSbVFUHEjUjqQ2aVqjUk46VKLLHh0gYPUDfrof
         yLFqC2CXuOjsaJISBdN3N0zrV5pm9FT03ts4y9CiGVoxGx6zFVEtJXt1yasVkNnX0HPU
         kE+NbZzU6JnGLLonroO948jA57K/RojGxUPQ47MTapxAIASEY4dHHfAaTeNO/ItoAkKV
         I0+rL36RGvmh9/hFFv2Yj9xGnHZbjAxLsvBPR6tILwPVLMGsj/oD/EoMENcMNebuvoyY
         Gjfhez7ILsYL6rs098ediLtxNUfuHL69vcDqUZiqwyvNRhLhG0jLqWV9fzZ0cQ6XPZE5
         CiiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=dhS8A80UKHVBBONMyyB3JNJOZLsQWUQ/neWlg69pPXo=;
        fh=dEB+1Xi36VASuiPAay5PUMxOg0OKkUsMkCbGGuJKutg=;
        b=ibLyrSjfzM5FTLj2UGyY+BBNHeKS3LdiR87siPXEER1TTyMZMsdNXawWLx2wtuKyR8
         tv95Y5jDOsbekbKtuaGEd8Sdb7MTdX2hlEYwfMXv4XQcmFOHoQdpwi8yqUpPeiuXVHJi
         DITwNmjDXqAg4q6t/iOyqRBttVHmlSDf0Yc442nQFb6G5OHoL4pBWghtwd6gyjKIdpr0
         1GLFWwIqW4kGiTuDlVxULzzpbD+lkhSuu0c3KbDYMZ03hR4cTUIUKV83DKLAmiGyCJv4
         yMNbemuHCYJexoE+ny+trvP5gTIVmgN29zeNqfcQ4evcE8ahzpuUMCGT0WGGQm1IvYqK
         Ze1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774288847; x=1774893647; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=dhS8A80UKHVBBONMyyB3JNJOZLsQWUQ/neWlg69pPXo=;
        b=TbfMm1TZVT4zWF1P4TKewfknYNd24GIKzyLliV8spvGalvsJIb36ud72Oo/zHnKjTQ
         QDAdCO5aZVphDrMop8qZJ1aXsoYYYbkNY5q9ru16W7aJvjnh5gyLvI9Me/+rYx3Sdg+K
         v4uF2kNpgQc24lDqqvUuoRk0Y58Kq3Gey+4WbADSy6jLARJF6zxgHhi3eFzKoF6pf7e4
         WJGVaf0BQ6xyYo6I59MSyN5wIqu1E8DydWyCQN5FB5t/wYlY9TCpuaiM0P+Bxf+ykARw
         khgkM2U9Gj0PtM4Ej5BcmOhVOrl/XlbpMPmTXSY59JiZlZj2EjOPw6CAxXSBKzDRBz6c
         DWOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774288847; x=1774893647;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dhS8A80UKHVBBONMyyB3JNJOZLsQWUQ/neWlg69pPXo=;
        b=i1iIWP0qIVmMeg34s6r7tUBHGBf07Jyl9VcT6V+sH9nnamQqJLoGXtm64cumb0TPfw
         3kKhJNun5iQXxw7TCTYx5gvIv641Ci70i4bSZkMfr1vNQZVtOEme095hxUJyaM3N5/Jp
         sWDlieQ0NxV/lBPau2qxxycH3jeOkGn5hCINmAeRcYGwNkYr72f4ZNlj9fEirZiZhH1R
         ofX5JQRlSZ0PgYBoWm+5LpYHw1DBrU5XucVRZg1oIhxGF6q6nwEpfXCK/JR2fm7UuuYG
         9q6KYHCEGaGAvCa4JWy3dVoG2xS/ZwxxCb4/8lc7EyX3JR57+byoogBIXi0wYLthjPQ2
         EQ3A==
X-Forwarded-Encrypted: i=1; AJvYcCU1PktfPNaZ7v88YBYEdd1+9lYsCKUGoW/3JNIXmpNU6TQYZNFPKs6MOwC40j4Bx+eqn0xUz3ePbA==@kvack.org
X-Gm-Message-State: AOJu0YxUBiRjCZdOkGIz0FywSUctt2j7zspbk/+zthZbdWOTijZC29wA
	jOmgJMphtPA6mXT2HrDHS0xvLSY95CXt/6vR3cJCPVdMHQcLCtRmawtGdH2j6bKTO+k0PkkBT24
	9ffs9wKU2arZmmqJf4aZMTJn1bVT+mpGPC1u+60xk
X-Gm-Gg: ATEYQzzzTw715/u0F4xyNu83w8OEaS07SGOxamLdveioXKE8rwzeTo6UCZstxy7dawJ
	tmtj7uzp8aReBbyj8jJvh8YbBeIQ7sEWdKJ2gv9fLzR7futIq56vsamt5TNhjQdcqQgdwA8yfIs
	G+jAxnrtIMUvOI7lpe0w/4EBztFMEikG6wlb4S3Gu7I6OIpBVRWadyOtguI37D7jF6T+Gbr2t/M
	Xfc+Odcw7RGHY5tpUTjUq3Dqt/5HOGU/77mxFc4x73JJdwcGBC+l/lzmH4jfXb1TwOIZyLgGvHO
	ZFLCILW0qA/R5pzWbL9NUi2NfKc+yyWROdqOc0k1LYDgbA1dSak7G1gKB7/OyXDHzfLrAw==
X-Received: by 2002:a05:6102:26d1:b0:5ff:ea89:44b5 with SMTP id
 ada2fe7eead31-602aed5357cmr6709465137.32.1774288846075; Mon, 23 Mar 2026
 11:00:46 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 11:00:45 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 11:00:44 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260317141031.514-2-kalyazin@amazon.com>
References: <20260317141031.514-1-kalyazin@amazon.com> <20260317141031.514-2-kalyazin@amazon.com>
MIME-Version: 1.0
Date: Mon, 23 Mar 2026 11:00:44 -0700
X-Gm-Features: AQROBzCftGX5aQ7J_uujSzbFVwlRhmdq4pmEC-kWuwHc-7ThhwmICNIjXxt4gxA
Message-ID: <CAEvNRgFUXsO4HLVvyjfU=UX9cO6UrRppyTu1X0_+6SXLhDEN=w@mail.gmail.com>
Subject: Re: [PATCH v11 01/16] set_memory: set_direct_map_* to take address
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com" <tabba@google.com>, 
	"prsampat@amd.com" <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>, 
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>, 
	"osalvador@suse.de" <osalvador@suse.de>, "pavel@kernel.org" <pavel@kernel.org>, 
	"rafael@kernel.org" <rafael@kernel.org>, "vannapurve@google.com" <vannapurve@google.com>, 
	"jackmanb@google.com" <jackmanb@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: deiq967xxpefgzbue9ufhkbagogzonwp
X-Rspamd-Queue-Id: 1BE821C001F
X-Rspamd-Server: rspam09
X-HE-Tag: 1774288847-394504
X-HE-Meta: U2FsdGVkX1/xc8CTev0gqRw2adBW5yQQDchOzEhIpwD/Kw9mYTcsX5uA3llDTrMi8KFj4pzKXFXdKi9NV+g3cOeXKIkwczmBDToqwRHKadP/G+PwY8HrbBqNN0XCdcgnSvq0C/mR+Dws3gL5UXg3aoULbuFHke1qAu+JGZAh6hSm7e2hSnTd/RqioteCuGhh16pNxUcp3vYlgge++d7WOOsBRRCOeS0O5Ocbb3QPjAHDGHC7tbqF2QiEiNAdGoUEkdLHSP/eKwdDhn7uv36/ZIN8rlvPK1wG7Ufhl8/ewK5HK2Cq4Qg1Ok35eHy4ThR1rM70NfTeFLw+Daw0bq8PYrSNYfeW5PrJXwLwj3ExlBm1T+ECPV0gJTkhLY0iM7eLzcBPKEjkEZ1Gt8gbrnDxjA9jjP+XR2lJWgJmnndEyj9Lm6refgbhcdVRYh7dPvHjISRuBS4L9zp3uDA12vLTVXJjUT+HglOQUdJN12irzt7Gt68dEHO1qd9J8if5eSkGJYMw+StXUmGRkytHzASh9H1P2uISYZMjO8mV1FnGc62yOj7EuDYOHUWktY9byJuN2Jnfnjm7l9E0pKDeqzXnaignupB5ACg++pP7BTpnC0bPOJMVSFDOYsPGizVqBDJbSRd0wgOmU8vq6CMEYoFKHvvloXwzaDs1/irDVz3gn1Sk+fUtAPa4HH+gnULWTpGEXbp90fRkAHhE9LCzdY3V8g5rKD1LYJy81c01zGncIGn4FmwQUO4eI9ICdEm0UnLL0zQOcR5zMmM9Tr6zXVzhaG78Oe8olJJ46psUr+NmxynMYMyQPgyzQJAAH43TMr8TNe476ZH7P5dATGmewzazFIRiCeC8YHJAgXSMBc6T3uaLsikciJB6V26mNQnoyNlj8Zu/v8ta9S6DDgX5PLSFjUWXXPLXLnRrN3Q47hBBKrN+9Ex78HTksTJHMQYIUo+QPZ0KUJqpGg+K5TrMwo/
 nIz34a8p
 7U30kV0WzomAkbihC40Y3QnSH6aCe1Qgj9hWYYMcp3R3YflGnBdRbsi7ACQknquiUVMVnGYTstEdyCPdBceCqiGy6wn7MA/Iu3ue5J83yxiNhELfunY4lnYRdly9MqdlOkOAnXucrwDOIQKKqsQemQnhcKJUYFQSdBXfMjFXwu2KOO/1t/dM2lLVS4mv78Zyy9S7QSpuorFFjPf2A87Nyxm63IsBSM+UazTf0aMrFd+UjJbES1xkBAFELUdWiJrTeFn70KN5221TTV/CUsZS+oo4MoFzi3/Z2ER4dqjvuSi3+YvOvhZlv9H+QetYhArt6t+IjMb5woTd3U1OINvfKyIgKs5y5uLwoD44UxqhCbaX4t8yod+mshV/O2eV5mvfwUt5y8Fs1Ij7jq2hCzSgVDibGeu+1vtX/8/hMyKr2O9qgDXCzXQHvNZOG4l8lwqlxyGa38otfeEwgtCs78A4hdLOKZJj6D+jk0LTEZYvdCM/ahErZ9snGgTCT/vnxTIntQjvnteFevUhgUViua18FXY//m89DRjxpG3YmL/IDu26vvoOl72Ah8Wq6WDe1Cf9RQk2BA+rpfR6dWyLhfKSrraJeqeW3qesZsqDLe+tTHRLR0BW8rzGL8jVLyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:

> From: Nikita Kalyazin <kalyazin@amazon.com>
>
> This is to avoid excessive conversions folio->page->address when adding
> helpers on top of set_direct_map_valid_noflush() in the next patch.
>

I can't take credit for what Sashiko [1] spotted.

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  arch/arm64/include/asm/set_memory.h     |  7 ++++---
>  arch/arm64/mm/pageattr.c                | 19 +++++++++----------
>  arch/loongarch/include/asm/set_memory.h |  7 ++++---
>  arch/loongarch/mm/pageattr.c            | 25 +++++++++++--------------
>  arch/riscv/include/asm/set_memory.h     |  7 ++++---
>  arch/riscv/mm/pageattr.c                | 17 +++++++++--------
>  arch/s390/include/asm/set_memory.h      |  7 ++++---
>  arch/s390/mm/pageattr.c                 | 13 +++++++------
>  arch/x86/include/asm/set_memory.h       |  7 ++++---
>  arch/x86/mm/pat/set_memory.c            | 23 ++++++++++++-----------
>  include/linux/set_memory.h              |  9 +++++----
>  kernel/power/snapshot.c                 |  4 ++--
>  mm/execmem.c                            |  6 ++++--
>  mm/secretmem.c                          |  6 +++---
>  mm/vmalloc.c                            | 11 +++++++----
>  15 files changed, 89 insertions(+), 79 deletions(-)
>
>
> [...snip...]
>
> diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
> index f5e910b68229..9e08905d3624 100644
> --- a/arch/loongarch/mm/pageattr.c
> +++ b/arch/loongarch/mm/pageattr.c
> @@ -198,32 +198,29 @@ bool kernel_page_present(struct page *page)
>  	return pte_present(ptep_get(pte));
>  }
>
> -int set_direct_map_default_noflush(struct page *page)
> +int set_direct_map_default_noflush(const void *addr)
>  {
> -	unsigned long addr = (unsigned long)page_address(page);
> -
> -	if (addr < vm_map_base)
> +	if ((unsigned long)addr < vm_map_base)
>  		return 0;
>
> -	return __set_memory(addr, 1, PAGE_KERNEL, __pgprot(0));
> +	return __set_memory((unsigned long)addr, 1, PAGE_KERNEL, __pgprot(0));
>  }
>
> -int set_direct_map_invalid_noflush(struct page *page)
> +int set_direct_map_invalid_noflush(const void *addr)
>  {
> -	unsigned long addr = (unsigned long)page_address(page);
> -
> -	if (addr < vm_map_base)
> +	if ((unsigned long)addr < vm_map_base)
>  		return 0;
>
> -	return __set_memory(addr, 1, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
> +	return __set_memory((unsigned long)addr, 1, __pgprot(0),
> +			    __pgprot(_PAGE_PRESENT | _PAGE_VALID));
>  }
>
> -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
> +int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,
> +				 bool valid)
>  {
> -	unsigned long addr = (unsigned long)page_address(page);
>  	pgprot_t set, clear;
>
> -	if (addr < vm_map_base)
> +	if ((unsigned long)addr < vm_map_base)
>  		return 0;
>
>  	if (valid) {
> @@ -234,5 +231,5 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>  		clear = __pgprot(_PAGE_PRESENT | _PAGE_VALID);
>  	}
>
> -	return __set_memory(addr, 1, set, clear);
> +	return __set_memory((unsigned long)addr, 1, set, clear);

Sashiko also spotted that there is a hard-coded 1 here. Before this
change, it was already hard-coded to 1. Not sure if this is a
bug.

Could this be addressed in a separate patch series?

>  }
>
> [...snip...]
>
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 40581a720fe8..6aea1f470fd5 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -2587,9 +2587,9 @@ int set_pages_rw(struct page *page, int numpages)
>  	return set_memory_rw(addr, numpages);
>  }
>
> -static int __set_pages_p(struct page *page, int numpages)
> +static int __set_pages_p(const void *addr, int numpages)
>  {
> -	unsigned long tempaddr = (unsigned long) page_address(page);
> +	unsigned long tempaddr = (unsigned long)addr;
>  	struct cpa_data cpa = { .vaddr = &tempaddr,
>  				.pgd = NULL,
>  				.numpages = numpages,
> @@ -2606,9 +2606,9 @@ static int __set_pages_p(struct page *page, int numpages)
>  	return __change_page_attr_set_clr(&cpa, 1);
>  }
>
> -static int __set_pages_np(struct page *page, int numpages)
> +static int __set_pages_np(const void *addr, int numpages)
>  {
> -	unsigned long tempaddr = (unsigned long) page_address(page);
> +	unsigned long tempaddr = (unsigned long)addr;
>  	struct cpa_data cpa = { .vaddr = &tempaddr,
>  				.pgd = NULL,
>  				.numpages = numpages,
> @@ -2625,22 +2625,23 @@ static int __set_pages_np(struct page *page, int numpages)
>  	return __change_page_attr_set_clr(&cpa, 1);
>  }
>

I agree that in arch/x86/mm/pat/set_memory.c, __kernel_map_pages(), has
calls to __set_pages_p() and __set_pages_np() that seems to have been
missed out in this patch. Those calls still pass struct page *. Maybe
that's because __kernel_map_pages() was guarded by
CONFIG_DEBUG_PAGEALLOC, so if you were using an lsp-guided refactoring
that call was missed.

Should probably try a grep to see what else needs replacing :)

[1] https://sashiko.dev/#/patchset/20260317141031.514-1-kalyazin%40amazon.com

> -int set_direct_map_invalid_noflush(struct page *page)
> +int set_direct_map_invalid_noflush(const void *addr)
>  {
> -	return __set_pages_np(page, 1);
> +	return __set_pages_np(addr, 1);
>  }
>
> -int set_direct_map_default_noflush(struct page *page)
> +int set_direct_map_default_noflush(const void *addr)
>  {
> -	return __set_pages_p(page, 1);
> +	return __set_pages_p(addr, 1);
>  }
>
> -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
> +int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,
> +				 bool valid)
>  {
>  	if (valid)
> -		return __set_pages_p(page, nr);
> +		return __set_pages_p(addr, numpages);
>
> -	return __set_pages_np(page, nr);
> +	return __set_pages_np(addr, numpages);
>  }
>
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>
> [...snip...]
>

