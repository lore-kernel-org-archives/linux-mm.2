Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C27F606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=AHYX4wed
Received: by kanga.kvack.org (Postfix)
	id 09A7F6B06EB; Tue, 24 Nov 2026 08:50:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0240D6B06ED; Tue, 24 Nov 2026 08:50:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2CB06B06EE; Tue, 24 Nov 2026 08:50:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4C596B06EB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:50:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 217D21A0AF6
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:50:14 +0000 (UTC)
X-FDA: 85470146748.30.B82B72E
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3F4D110000E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:50:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=googlemail.com header.s=20260707 header.b=AHYX4wed;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=quarantine) header.from=googlemail.com;
	spf=pass (imf14.hostedemail.com: domain of cgzones@googlemail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=cgzones@googlemail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795528212;
	b=CqRbBQ451CP4T6K8wqndluElBxvT7hgYx5szmC43gogk3IhmEueOt8mC4zsI28t4QD03uw
	h8T7RVxcCOWYl4s1uEKX6ba1lBitQZ3MPVrTJBIaSpP/k0WKXGsgeczouejeXJbiEfjw/O
	zb/3pCrJ1ljuXQrLkndeN6RNLLckkwQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795528212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XTPCHg4unEN6vtUDvCIgxfYMZVabwQIC4dv3+3CL15w=;
	b=KO9Xss9LCdiFwzK95Ot14iwOTHADWd0+dbSWfj1QhE4bJ71lKci69N/TD1O5wk6Uh4OxvE
	DDKGJB/6hp4x+iN6l8gVntFPQrveRyckmxhI4jZMYpdPGkkwA5GUpOs85RvCKuHhr2sf4F
	DFmfXyqY5JhydV4W393LLeH/X8MCsUM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=googlemail.com header.s=20260707 header.b=AHYX4wed;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=quarantine) header.from=googlemail.com;
	spf=pass (imf14.hostedemail.com: domain of cgzones@googlemail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=cgzones@googlemail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4bb606491faso24852035e9.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:50:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795528211; cv=none;
        d=google.com; s=arc-20260327;
        b=f80FncKhyZk17EHtSBCa5nXck4oxe4U4AzvbwW57+4Rd7dQHUTk3I2C7P5gEBvhID+
         VE3uJHEaRKDRRR3W7O2cFabs/gkPyzZegv0NZL74XyxAfgCTKT1en8Squ4Um9Y9UTXEm
         UQaCamjwjBZ64OUyuoRRiaW9L0xhpTo8r2l1l4kcslM+HVXjGIsrEeqedupC2L84k8KA
         lOG1QpgppBu6gClY88Ag9/5BcwE02xtMn4Zh9QrPOmeR9Chn7qNrp0Ulk/swweMXJ3dE
         6HeFuTDssE+QL70SUOoE/qC4tPrS1EuFbp1VNZAH2IeLoWjWhip4qk12lN3YvCsk4qGX
         1iaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=XTPCHg4unEN6vtUDvCIgxfYMZVabwQIC4dv3+3CL15w=;
        fh=i6USxftkCw20doTiB+duE+mncwr2kjS+gjPkXOqxF+c=;
        b=bCtJEUh28JQPJlOFIlvQUZMzkGOqidwRtwyMk4Uc8FpqKm+ioCM4mfYB9SDF0TaOAq
         E8pFdIioeaEJZgpS0oTNQ3HrrYq9v7SD1xTkDdN2zcQH/Ln+00uJLAjifYgV6nDbkDGE
         vsAVDcq9MjDGqDzDsUB5pUjRLvjhoQCFkIYaK9G20OI5MBIBtRbUWhrh1/8vkU12tusp
         Ig/Gnoi4VlbTITIw7t3qBVvbji+/uSQFdJuZWiHDCIJSXuPvVGiV7b0M8mS1EPNfYgYu
         Y4Jbo3qx6hLmKiYTT+aJpgSYcZtBv8lHLrgl6nBJpBqq/K72ZLbalUdUtgZb2+4mSNbd
         5W8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795528211; x=1796133011; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XTPCHg4unEN6vtUDvCIgxfYMZVabwQIC4dv3+3CL15w=;
        b=AHYX4wedaqbMnqtHWSw4XjSFUKB9lMW62msUJgEBVjpXgghjhT2Yks3KaN2iZb9FOI
         MlsprA5NpdA+7DLhuIm/1TJBLYFWvdt7v6bJNt75L/cjh3LlM6diPAv8OCj3HzGHlq2q
         6EmX1M6EVkxSwTBPDsY3dyltpgv0keS/6nl0essQDtoX+plnNG6mDRF6+2VM5Ew09OK9
         pTe+I4vx8bK+xeLWrn+tz3DVKTwWWbYbEfnPA5WAU/jH+TeHVWsEcqTIEKVIqkvRgyXn
         agpWu9jx/sxmSN7PYXXz2b7rcbq8ah3A3ssNjsstStzZTPd0T8ndujF3SRJnCsBWkRuX
         6Law==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795528211; x=1796133011;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XTPCHg4unEN6vtUDvCIgxfYMZVabwQIC4dv3+3CL15w=;
        b=adZ72IcCjggOWLTLcToL5YjkQMXicFhrwIvQRa3Ded//GOjGn81s/j6rgBfDcgzbQN
         YAPec65f+5+DcJaAmxQemVZdrrVP5Gcd13M4kTooQyO7yur8yfNloCQHaGOdNYmZPHJC
         PGY6lcUB4o9SSCjsgJS2zoe3OZ8hKib5JhZF2usz0m/vSjMjS0N7Jg2bNK9aGAuIJOwa
         4qmi6R3Aj2JRvZ+o7w6brsmb11eV4SDreVpEF4f4svGhoiUO++PPOlydtq6+HZ5dFD4I
         2s3Ff2FiEvT+/GprlsEoVqLCVkX4CvFNO7j0K1mI04mDvOEa4S/CETBGSSYymD/0qjSW
         rBRw==
X-Forwarded-Encrypted: i=1; AL+hErH+GmyBem65NBoWiGHGC2TNZvV5YmuX8uXIYuYuGvgIuWW8MsgxZ34qho8b1Z14FvlJZqm9kRLw6g==@kvack.org
X-Gm-Message-State: APuU4Z80YjW3ehnviOdlrWEWbC8au1+6wi+rNsapbWfa8ENGfgZOHOH7
	qbDeuymPeiJGsHs6XZurn+ZaUHs61sJKKkahJy1ITn4LSOTXKCdSWuG4DXjSMXt+VmjOwKjrEZ6
	0CSdqkNXQjFNgmCzgOGdueQAgORTq9rE=
X-Gm-Gg: AZFdTZedE2VDA/1UUhlHP0jI+TQa7ulccIxR5Bm/TvtCsPJtSVk1gcSriZobZ985zRV
	kviuIOnsSpRJU4AId+VZ+oWa5NIY7ne3sEf9Ew/tqmRPv/s1A6IoV15RaLu7Jd/8gXvj4xVhXHm
	GLUKqriOJACIzSRF/nmOv4T6PgPDSgWtFFkWoxwjwjauKSyMtOE8TVCv2WWTvvQRXtCbe56Wzch
	b+S7bmwX39f4Ihed7K9d8zD5BDDftX5zgG32RwEVY8Yv4ldTZpc0KCUEGJSRh4GxY72r3LS8u8/
	iRO/lye2FvKpHf7vG1VSywlphhdBruCuztpj1tGhWCintvDrd2TSnFHTEPZCiGCBpffIka3rOkf
	RiZQh8iRWh58ibSg+EYK/goj/JnlgjOS8RcVa4CB45PCgq/peLNbI
X-Received: by 2002:a05:600c:800e:b0:4bb:7757:fe58 with SMTP id
 5b1f17b1804b1-4bb8881b9d7mr305306125e9.19.1795528210579; Tue, 24 Nov 2026
 05:50:10 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
 <20261124-v2_20230123_tjmercier_google_com-v6-6-dce12fa03ad6@redhat.com>
In-Reply-To: <20261124-v2_20230123_tjmercier_google_com-v6-6-dce12fa03ad6@redhat.com>
From: =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
Date: Tue, 24 Nov 2026 14:49:55 +0100
X-Gm-Features: Aa3M54qkPJ8C4GRzLQzCC_QtBShd4rpGnT89RPbtOkkrzzkAiMVQPjTTZfQmmls
Message-ID: <CAJ2a_DeDF+9pbLKS9pcX4Tot4xZZ-K7HydKnDjW6TWC5bvREzQ@mail.gmail.com>
Subject: Re: [PATCH v6 6/7] selinux: Restrict cross-cgroup memcg charging
To: Albert Esteve <aesteve@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
	Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	Philipp Stanner <phasta@kernel.org>, airlied@gmail.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org, 
	echanude@redhat.com, mripard@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3F4D110000E
X-Stat-Signature: mnbpz5u5d4oehw919gtu9qm4o7pyd6sh
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795528212-70441
X-HE-Meta: U2FsdGVkX1+DzxjunBXJYQpCjaTMe2op/jzz6O4gf580EikWtQGz0MhfrWISFEbRHk2GWWNxr7TrNsm9y/KH4K17TsFDnpstX06Y/pZ959NgZrhPVrO1roAQThTSKDlBWkv4d6kompuWYuq34ZYd7oIS5kJSiq/rJn4mJidQQ/sNAPqJ/FZn1NlyGj9bag7gZg/s6z4DPfAUpkjh6CAdOfWrlzcb8NNU8V84Sj8UfvXMcbAOQ8g+KDa0R6AcDjn9xZA6MqjqJvThqt+KveUn7+McZxt+UQB8ilgEdW3VuWNdAoPaDMyhoIVPxKc74Af4hHzIZ2ke/bsVJxSkUy66nzclzgCoUruz29eXzMtaoEklYWuf9f+ya5fiGTTZThsuZXJZP8BFjBf8/PrQIvUOu8KKIbuwvUedkF8cvTIKNt9X4I3BAjI1GCCaGTDJnoApHso0TSBPSBprJp4YEIR+EYfg5nbAfAnGyqyx7AqlQ+lMUoz+U2Qyg6qGFRCirzBFI49+4+RB/UFwRxbCeLmHhTXoGjh2RrDQMys1G4WITjfY752Ht/ot65sG2G0+yAiFU2NbYE7GHEsVWxrFpbtIAmyFeDTQkVJ2Kbd623GIAcv/EAkPml/QBEwa8ZeSZjOgoXuGqdWIB++9ZmcSMNQhdLcMZPCztazruho20QrR35i8AG5TpcpVQ6Ph4jGdamgxKQqcVCP/tm3OSs30XfqbJuv8de6VA+hWqlqQLtUEnlowWSKorZJbfKRH3tTk3vcI5iTTUbe9sYMiIW5i7Nx18mpFFAHkJpKGxBjSpDO6+IGZ/xrtde3Z1tmY6fQbldjvblh+um4IIUmfYNCVk5kwzPBHGOaTgksdHPb5QRJKrF4h7189vyFlnmYkaKVlsrvJVZqsVlUPcmk7kEgTTTJ2UaXrwHRpPxyqYt1fzwH1WJe35Mnkv+JrppvBnHmYAgp1Lmfk0oaiW3LCkFtqBc0
 WtxhqDeu
 6jaIbYIuR3P/YZkox6+23AoUbwhVjdNgEdjkDqvX/aFU16xGQQwqBBBYiOYkByxJCHTrotU8p4jauwD/XzNpNWSTiLULOOWCxTNLNOm20So4lg0PxbYn2EbveGLN961UTxzKaQQWZK6606UeHYbhRaXLQkeZM0vU1v04fworrLlETNcaNZx3DLUrsaBVFuc4EMFCUgK8gkp+YbwyRTbZFP2k+F5KqhVZ80EC07gq10NE6pWAI7Z+Hm3UVdiMHtfQ9SLJPXkjcLFrkiRjJwRInouUlXYka33qQqc2WQ0ZPNCiIL6ZONGgIuBAwSUX0vez/c4UY38n6lhhFCKhDx7bhUNi5YZgu0eR62r5AJMi1MlCwMPQPXo47k+sraykRaaVLWbJwxazBSBXTafFKY9OcUX2u7FZgMndW2C4CXPUwlMYKFpwrFHs31Jr+vOV5EA/Uf7MCJcEmwGqVpEicIIBrfLeK9vodRCYYyNShNtt4Ir8c89IWSlMaYw/yRSNUpKGuPGkIOtPgf1KSJLSJOgNEVALa27RFiYhhA4in3qX7iHKr41LTthmjgF0XcXrZCa1YmOzoyp3ch0zxn9w21jRPgTcNEdRoogIW/4Ad9rYhFdZE7w0tfn371NxPoqZFjPBnvVjPLbwmX+gqgCp334aC5he0qRo2NjrKjGvjQRyFglY/TosgPBVyBmS1QySIgExHmseY49G5Wd99OoEeJbBW9/XIYSoUN9vKIQuP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 at 14:05, Albert Esteve <aesteve@redhat.com> wrote:
>
> The security_current_memcg_charge_task() and
> security_current_memcg_charge_cgroup() hooks allow security modules to
> control which processes may charge or transfer memcg memory to another
> process's cgroup, named by a pidfd, or to an arbitrary cgroup named by
> a cgroupfd, both passed in charge_fd. Without a policy implementation,
> either hook is a no-op and the restriction is not enforced.
>
> On SELinux-managed systems the only limit is CAP_SYS_RESOURCE. A
> domain that holds both dma-heap access (today's only exporter that
> opts-in) and that capability, can charge memory to any cgroup outside
> its own subtree. Since the capability is all-or-nothing, SELinux
> policy cannot express which targets such a domain may charge to.
>
> Implement both selinux_memcg_charge_task() and
> selinux_memcg_charge_cgroup() using avc_has_perm() with a new cgroup
> object class and a new charge_to permission. Both charge_fd flavours
> ultimately charge a cgroup, so one permission covers them and the
> target type keeps the distinction: for the pidfd path the target is
> the referred task's SID, as there is no cgroup object to take a label
> from; for the cgroupfd path it is the cgroup directory's inode SID,
> which comes from the genfscon entry for cgroupfs unless the directory
> is relabeled.
>
> The checks run when the charge target is resolved, before the
> CAP_SYS_RESOURCE baseline is evaluated, and apply to every explicit
> charge_fd target, including the caller's own subtree, so policy needs
> a rule even for self-charging. Policy authors can then grant
> cross-cgroup charging selectively, for example:
>
>   allow allocator_app_t client_app_t:cgroup charge_to;
>   allow allocator_app_t cgroup_t:cgroup charge_to;
>
> Signed-off-by: Albert Esteve <aesteve@redhat.com>
> ---
>  security/selinux/hooks.c            | 19 +++++++++++++++++++
>  security/selinux/include/classmap.h |  1 +
>  2 files changed, 20 insertions(+)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 6c4c64d6e904..76a714107ae4 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2204,6 +2204,23 @@ static int selinux_capable(const struct cred *cred, struct user_namespace *ns,
>         return cred_has_capability(cred, cap, opts, ns == &init_user_ns);
>  }
>
> +static int selinux_memcg_charge_task(const struct cred *to)
> +{
> +       const struct cred *cred = current_cred();
> +
> +       return avc_has_perm(cred_sid(cred), cred_sid(to),

Small nit:
`cred_sid(current_cred())` could be simplified using `current_sid()`

> +                           SECCLASS_CGROUP, CGROUP__CHARGE_TO, NULL);
> +}
> +
> +static int selinux_memcg_charge_cgroup(const struct file *file)
> +{
> +       const struct cred *cred = current_cred();
> +       struct inode_security_struct *isec = inode_security(file_inode(file));
> +
> +       return avc_has_perm(cred_sid(cred), isec->sid, SECCLASS_CGROUP,
> +                           CGROUP__CHARGE_TO, NULL);
> +}
> +
>  static int selinux_quotactl(int cmds, int type, int id, const struct super_block *sb)
>  {
>         const struct cred *cred = current_cred();
> @@ -7683,6 +7700,8 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
>         LSM_HOOK_INIT(capget, selinux_capget),
>         LSM_HOOK_INIT(capset, selinux_capset),
>         LSM_HOOK_INIT(capable, selinux_capable),
> +       LSM_HOOK_INIT(memcg_charge_task, selinux_memcg_charge_task),
> +       LSM_HOOK_INIT(memcg_charge_cgroup, selinux_memcg_charge_cgroup),
>         LSM_HOOK_INIT(quotactl, selinux_quotactl),
>         LSM_HOOK_INIT(quota_on, selinux_quota_on),
>         LSM_HOOK_INIT(syslog, selinux_syslog),
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index 90cb61b16425..1f1f2fc4d35d 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -181,6 +181,7 @@ const struct security_class_mapping secclass_map[] = {
>         { "user_namespace", { "create", NULL } },
>         { "memfd_file",
>           { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL } },
> +       { "cgroup", { "charge_to", NULL } },
>         /* last one */ { NULL, {} }
>  };
>
>
> --
> 2.55.0
>
>

