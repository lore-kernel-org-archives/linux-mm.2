Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9EE3CC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A857D6B00A0; Tue, 13 Oct 2026 23:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D266B00A1; Tue, 13 Oct 2026 23:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972C76B00A2; Tue, 13 Oct 2026 23:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6838B6B00A0
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:24:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0304160419
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:24:31 +0000 (UTC)
X-FDA: 85319789142.06.4F53609
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id E6D3440008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:24:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=At9NI9mZ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791948269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5W3Yp3oK6NosuISWrK7hbNW+ZeNBXIIyZITKoeVCL+k=;
	b=Qs7FK7ONzvGd7W43I46L3nF/KKGbUeh+EjNe5r36NTfMom1gwasjZkXCgITbnIQ4GH52jP
	e/pRgdl8ZfD3BLdVWnQHgNzEU/Zv1DU5aRnymsEJGdNdbL6vcztqpGZjCp5GGlg8ltgsHY
	sQJLM7NMvXz5gvYzHbBaIZl+aQ9wKjk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=At9NI9mZ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791948269;
	b=GEDrx+5eaQZY8O5wYXs7npORa0ntB0wiTtnnCk/KHC/OjSyQ/e/w0VHjwiUHB/NOgc8sqX
	/EjafokMN5kwlQ3CBTfAZegxEjRIYKdfUYYeclZ0fGc7MDk0gsjS1+Ha3++2qxGGp+31IS
	O0gslx4xVKAz2Dh806LYi3miU23MZy0=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-677aec6ddfcso3082653d50.3
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:24:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791948269; cv=none;
        d=google.com; s=arc-20260327;
        b=k3sGqoG6Tq43QIUwNTb2NiWogQrs3L0rFQf911jCS6qcQ7Jo7uIiknbjrz2D84YJoW
         /6Myc2ksdlP3LPS4xGlIk5+04Kj9q78wMwJ5zQTbTm5RjkGj3xBFZfP1UU6aW8GmfeN2
         jiHHNd7r28bpP9fLsWYJ5m/5XfOYmU9yw/U8LhNLCN2zqKayOlXwyqL6pdbV8sfLVpK/
         d5mh9AFMvKIqIcYMOsmSlINiY8VObT8LjZLQMFDOgHg3Hc8D5YijVsLGQP5xCZY9sQui
         JpAlLwlyf2nGl1H4nMNP1GjK/Rn46ZYQdqx9SAuRJQn7pll1eakkzQ8WzmmH84AzP4ed
         eBUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5W3Yp3oK6NosuISWrK7hbNW+ZeNBXIIyZITKoeVCL+k=;
        fh=Cz8fO4Qa+lOfqyu5hqu0/wWxHk2bN+JCylnyrEcv3PE=;
        b=rCssE8gELdbCcG6g8+WRACmz4cH/jejQdzTmHz2LogKUlxcS6epfjWXTUt4ZhFy93m
         WnIsRRBfpDFnieObw+ayv3l/FoJp1QimP6zRZFEJSNzYvLeZ3dUSVzJSzO9z2st6SNM4
         o6sLkvsh/kNEJLztP8EISkV8uKnNFLNSI2YVUFTwuyjNP7y4MBXC2z3LoOQU+ekWlbt8
         8Nsi+r1fn4vzJ2lOsL/5LI3NsFsXcNNWKCugoBchOBdTDwm9pl8glQ3I7alm6p8B5bFf
         LW17xykfF+K03yxmSVcgmfSQKQJqXzdOg7dYp6xwNKd8VWWrZrJTmCrul7zpfaPhizKP
         kC4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791948269; x=1792553069; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5W3Yp3oK6NosuISWrK7hbNW+ZeNBXIIyZITKoeVCL+k=;
        b=At9NI9mZzyYoc37JaEvuTzqJbfgZon0rTIGu7eehtrk6oLa4WgSmF0HxgPGPDZDURw
         nBA32XIx4rXpqYTkNBQBOpPmPZgBSfyiMSdgn6ok6lw4pY7TOqovmVkzh8zbndItDyaE
         8pqj7RyOnaIesB/vPFFjUmRFwOx/6mLmI7djV33n/p6y3VXiUmntgoU4XdrwLm3OJer+
         siSv5lD8YfiH2CkCwDQ3kt3YxScgrPkmwj++MqBPDXi3kCH9389AaANSrfqu4EQZ+nb8
         01/oE8sOK7AKCNVYKAA7dBb17Rij4O3YTCCSUa/T8yM4gyx8px8cbcOLLirQ2pUE25+T
         6lXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791948269; x=1792553069;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5W3Yp3oK6NosuISWrK7hbNW+ZeNBXIIyZITKoeVCL+k=;
        b=d0MFgMhGmjyaGGTcqwytQup9/rxeWA7Gr9W36fDYk4vO7PfhLNC7O466wrFJ6ggGfI
         UEEBWfl7CoLbo07xm1W318EAxwLUTr3wTFVtNHOf/6EwN0dFvEJe7dLZti3WSw4rxAZq
         JtEhuj3ueRHMdnbVB4qD70IREzJ4dlVScPD58VLKY0eAhzds8wThxeWbLbm4uSpg3mZL
         SYbJOLbQbF1GhBHT+cNBxgDWc6Bmp6/eNdp9akZ5qXj9PSZK48CnkdryfezVngWifZuP
         aItwi8z5eKFxXClloxey3Rkz/PNZh/p2sibZigzjXLwElk1kdFMfeIciSIzRTDJV8kd0
         nqMw==
X-Forwarded-Encrypted: i=1; AKwUvBzSwRvfZ4HAKYtxo6iGhlCTxbfW8G5T0czCmBoDegcPTZRJWf1YqLHPJUrYngxSn6eOzvPK9DiEvQ==@kvack.org
X-Gm-Message-State: AFq9FYKgOtT9OQUHqGDwUSxjqYy07Iq1p0rDdZcY5ojFeuJtD0z7LJ2h
	Noyjo7fdziIU82id2CMwTPP9jGB9SzUQgb4ufybHjkHFtpylspbftMiNpLOROxkSfy+sbT2bgUu
	yQgV+cIg8HT9edbZQi7SABtFzmQ9lZ+A=
X-Gm-Gg: AYBFou2pH8bGTzzmSH7X5FezRDKUE9Im2TwQ+lslBiyy39l/JrqBOXttIOopCiHvmjh
	OR33H84IBNCpkMrKbqc2VzuRs19CQlzn8AbA5UCfPZfcQ60oyqrnlE1Fkf2H8mh+m/ND48RZE9H
	g9r/2WryNcofE6EP/Z8exZZCO3Xd+OXT6AZDqFlHKF8JmGrMDUifKGG9fHDwpYr02dd1i3QxBG7
	5v4JjDzTwrEtJUlorfKhnWV+G70j011pNjODXLZq/qjvctrtacfc9R/2uvwLkdhs6/CjOiUFzFS
	8Aapo+eZa4VcfDWIIqhQjGp+6ELIWI1MzGkaK3g33xRZFPF4FgBrWhP94MAjd6Xe7U3XkypETDx
	odsPJWkR91A==
X-Received: by 2002:a53:d017:0:b0:675:74c6:79d with SMTP id
 956f58d0204a3-679362ac182mr3741120d50.122.1791948268949; Tue, 13 Oct 2026
 20:24:28 -0700 (PDT)
MIME-Version: 1.0
References: <20261012120438.52849-1-laoar.shao@gmail.com> <d9a3367a1852158f60cc2e89677fb12f@kernel.org>
 <CALOAHbBE_1ssK_26c-UY7N6WxhkVNpB6v9WACVGaOiWZ5zchCA@mail.gmail.com> <3eda489898ebf7c848ce61760af745d9@kernel.org>
In-Reply-To: <3eda489898ebf7c848ce61760af745d9@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 14 Oct 2026 11:23:45 +0800
X-Gm-Features: AclHuK8rh2AW6bZVG8ZqRjg04D-kUz_OaCPBeR9yqJbXuPX4vDKYFO4Wi9z6gLo
Message-ID: <CALOAHbB58xLBdBOZCwJ=4yeKyvGvSsX1wfeAXehD2SGHSmB1+A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/3] BPF-based per-cgroup NUMA balancing mode selection
To: Tejun Heo <tj@kernel.org>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, mkoutny@suse.com, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, 
	zhao1.liu@intel.com, bpf@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E6D3440008
X-Stat-Signature: cbj95y1mp4j58o68zfix1dad5e7ok9ks
X-HE-Tag: 1791948269-767349
X-HE-Meta: U2FsdGVkX18fiBHiG+tAxbh77fcZeXPxPFOhrsrfqKV2rbjIhVejyq9Lynj5HJm/ppFsoieoqtKM4BoqRu/oLGXlcu/FeyUoMmt6a5DcZjdjgRzQvoxPGRxxUXGnKE5sEmzhlh1O+NYgU8hgzYH8VBtrvWgTzled1rEPYivXUXsvTs3saeNFhM2ONshJwV9LyNJR7TEuv6qOs5zGHU0R/XZQEhJhJHkrB1/v3J+pmxeaP4v7yv8plcbeTuVNYndfaXwMrfpOrtfbpjmhwDHXQtY5h6+0oaJehsywsHKVDT7aAALF77d2lkdcr8DI9Q01JlJz1BykpB/EvFou5bDJHtqwx8WEb0z7lPcfeqo0HOCHPdo601+XnleAfaxCWgrWFqK/tCAHYvADXP0uKc4YKAihvDyavPizXXRm9N+2qFVhzFTvkn0F4oFgu6KyDbbvuJzSoJLkhftiLpIMY2XXnMwoI4zNz8YdQ+1FxDiDrUsVSiQmIAcLvGFCydK0L+zA+V0SJTWlUwhDwePyxqmwwTB8wwXI6gcgCtPukIGa2tl7lKSMRlF3jRvcCCWBnpcMtp+WqM+zvazGuGsorzPxgVhmYDDlB0X90ec4nJIMb0j0Ut8mHtS1Qe2QZircKLVpdfutqqBGWvOC4PWzFG9V8MLoDb+ojEYgzavIu33aRguldCJaXINPvT1JHQyASh7rg4WLAqDESuVzZ0iZoFpAXLUfxxaxUHPT4FmqV0rViYJxcdou8201DePIZGCg3zza9YwBzdZhAs0tL2z2GFlACfUStnnykMfUnhjsBHSo4KELs6Cgqr2b8+2Csgz1KVlmNAR0mv7lgju/A+s/Ni4QXC7XuE4GOjUjGb4Kp97zJpqiU1onY+O5xeBOOqXqTobiCRV54ZOveMUmrQb4QshZkC7i2g/Cbj0IFPNfEnUnHZno/XC6mq/5khKSvu3KXg45520iAL1e7yCYSLogzSg
 OajSdnvk
 AgQ5+h9fJ82Kj8858LkC9PSt7qasuZNiIZ9GMjPU3MOyibtM7PJmtRClcwRdNeq+qdGYcXj7owxWfkOEpu87rZ8BhrKUMYNBZQ5zCdKF6jBnpRmsTdPepcSiNUZd13RJ9Rkxx5sFnbwczMnY0bLWDcMNU63GfzTJzzWvD8YXEPK2s36On8H5mc/7DLqdy57oQ7oGNmKz5VeneVIW1wcXHlowBe5NXNU4HQkADD1ySZg1AKJKBqaoi/Y4IWn8SQalDv4/LquA3LCxokMZN/drfY3zViWmhzD9Z85nBnPatyJeRHZky71vDnIdaHU3ap6bbbee/F9R6Eg2FmgIlocpzbjy4U3+nRXbjae8ZozXIHGvUm7fEqA/Eqocaw4N1QdF9Yo5IIUZS9hqDrUihIyZVru/9TB3/UGqlp36z4brlaxsMNTVmbNI4pl90sDxF2H3+wrPRwVNtjfThGbw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 2:02=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Tue, Oct 13, 2026 at 10:16:32AM +0800, Yafang Shao wrote:
> > Part of the consults are keyed on struct folio rather than struct
> > task_struct: the folio surface answers from the folio's memcg, the
> > owner's request, not the touching task's.
>
> Right, and I take the prctl() point too. It's stable uAPI and too rigid
> a bar for this.
>
> My suggestion is to start smaller. The op doesn't compute anything
> from its inputs. It returns a fixed mode per cgroup, and you don't
> need struct_ops for that.
>
> A kfunc that takes a cgid and a value would do: -1 for the system
> setting, otherwise the existing NUMA_BALANCING_* bitmask stored per
> cgroup. Task callsites read it through the task's cgroup, folio
> callsites through folio_memcg(). Same capability for the use case in
> the cover letter, a per-cgroup field and minimal plumbing, and the
> kfunc can grow later if a real decision-time policy shows up.

That's a good suggestion.

I believe that will be a good start for other per-cgroup memory
management features as well, such as per-cgroup THP.  Also, it is
much easier to backport to older kernels and rapidly deploy them.

I will draft it soon.

--=20
Regards
Yafang

