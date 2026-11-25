Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84B95606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bk1ZGJl0
Received: by kanga.kvack.org (Postfix)
	id 7E5E36B0A10; Wed, 25 Nov 2026 08:27:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 797396B0A11; Wed, 25 Nov 2026 08:27:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC286B0A12; Wed, 25 Nov 2026 08:27:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4156B0A10
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:27:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2707C0EF7
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:27:35 +0000 (UTC)
X-FDA: 85473718470.07.C964260
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 21F8B180009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:27:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bk1ZGJl0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795613254;
	b=dJ610d8lBqP5dsmKpZTOFDHIkaFW0H+nqxxrE7rHBxCAbrZBbp6r/9tC7gBCptijdTfUGy
	zt9XeJ463F5jbJvQaVjV0TZwNdgJVWelau2nshuCdUFKPARLungRoHbuioDeIhL/HMg7gR
	E1WOj//+DeBHitslEj/u1Yq8bi3OL3g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795613254;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5gHCchVhFhdOMJqGmOLCKhYwQb/s46rivVW3uM5pk4=;
	b=OKbb0N8CCkLDpjT0n2X6PJRPBc29mjkyfBkTWVYVGXscbRkbA8U0pV9CqRSmt4ov10sWr9
	Z8ATe6XP6O8fAwFDgT4j38pnCIrPlI6pYIhe6GqrI0bso6DJHqDzCdixyZUIYzWKOs7iIB
	4qRjUjX2XAda/bKwYhtFz7lbWAZW5G8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bk1ZGJl0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A5BE600D4;
	Wed, 25 Nov 2026 13:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED20E1F000D1;
	Wed, 25 Nov 2026 13:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795613252;
	bh=M5gHCchVhFhdOMJqGmOLCKhYwQb/s46rivVW3uM5pk4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Bk1ZGJl0mQfsOtZAG9hZAygahYGE+v8nlNZGWTBoaiKHWOty4Tg9Epnvn44UmyC9S
	 24/qBfeLBg3Ngvzc0fWUegmwF6tU2HMQN68N6+HdslpeKzGD2QT+O5LDaPzbHKV9Q+
	 PC29sZbtpCTlfcR84e7t/JGCyKY8Gnoypyz8gTb/N91hsBBgA2aSB9Nbw6lamelJj3
	 QFy8tnq4kUTThHwr2s54ZtN6GKWCdYEvexR/ma+KqIBnv1sgTHD0JfbRfIw5TA4Ju5
	 iBDRLrButwu5x5RdOwABqn5XGioyGYYIvrCrO8aWu7pqqj9a2tXB1GekRvGFsvxvJJ
	 9V+PXCABs8LXw==
Message-ID: <sashiko-outbox-233490@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] rust: bug: add warn_once! macro
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ivan Tverdokhleb" <mbkchelofficialdev@gmail.com>, "FUJITA Tomonori" <fujita.tomonori@gmail.com>, "Miguel
 Ojeda" <ojeda@kernel.org>
Cc: "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?b?QmrDtnJuIFJveSBCYXJvbg==?= <bjorn3_gh@protonmail.com>, "Benno
 Lossin" <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Daniel Almeida" <daniel.almeida@collabora.com>, "Tamir
 Duberstein" <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>, "Liam R . Howlett" <liam@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261124132707.101769-1-mbkchelofficialdev@gmail.com>
References: <20261124132707.101769-1-mbkchelofficialdev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:27:31 +0000
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 21F8B180009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ujrhmprzirkaeps1kgcui84xuw1snyf5
X-HE-Tag: 1795613253-801837
X-HE-Meta: U2FsdGVkX18Kowo2DCt57j9OelqPDaCJM8eNFjYprM3dg0YFLmVofSQjKsTkvK+EjAw8sqgITXu9yWWXdkvFSsRUTIiCp+6ZI5qRfG1rB0gPNoWZ7urh9l8evtyyd7tiMsCAOcsmQy/+l6652juapU3SsZvMg0W1R91dZsPx6VfuRj6rU9QYsfElIm1h+506i1Z/AMMK66U/e898chFMyS9AKu3qHZ6upc28rupHSZMKYxmmhsd/hIFEEZNH3LvNjC10sOo7h3miUyl8lNHq8wW2cWt0xMGzepz6OqaUYUoNpRFrd+MwG6DQSOk5zz4MqopLFGzonS+6BD9VyZDZ0wNmF/tlibsxTnT1YhWHONtHL3wQf+QgJ4BmN8uud+HW5X0XiinocfRzabqmtfTMSaJEn1AxJQ13WzANMDxklvIKztLlyIAvZliQvMyw65jLb+vS5NnvwaOUqmoP2izPD4b6I50U6oXw/Zi5qBPGOF3iMfvyh5ryYFDwcY2xSMb2RT98VK/bNyo5P7msY8nH46FD9+MZ58uQqtApHptgGoUqeGwbB5nYZUg6uu3rh7mCCC4wbNtktP2/s80s7LmeiG3Ckh84D5C89PYgjgEzshnmtydD1NsHCF3aMGDQ/Oo0nbR9gsHep4LchuCE39cjHcatVMntPvSyrwsnHQxrNkvwwnC/fzAeqaJFn5faOvfjNMpE1vO5eQunsuxi5dxiQ3pWgnI0xHD1vEfxFuJZth+5u/Echfa3xcIDsPNioBLfzrV7On6ubdZxQdCggaoIKXYlV2ZTkofnwl2z/JdnBe+z3Y5SiSpTYORlrl/ZJZ9GXGsEmuFKGafPU/QunopDrSeNcnzRXTawpq+jaTKulGyKPqWhPpNjbdTzi2i8eqqrWJUhgfN8+7XzVUrJT2ayIWejjHWcQcuPpe3bccMqoxME7k7yiUhCb4S2YDh1JqjVJRi511Y5Eaa9StFPaXV
 1ZedkfxL
 q6HKsDeAzmtiiaYGmkAxO4i6pOmbs8uNEBXu8mzV4RmGv/izvWb6ibZS5xXz6/YspWknPiL9cRflHGV0P52h8mH+Wl1t6xFiTBAqW/cEShs7XcdfjIqUmZP2iLwsdUUJ1gCjEutTiEeYowgBA1NdV11j1noXanZLFemufO6JVTNmBnD6Nmtm/RsvIl8vtO1yzUikSXG0NSHkVlGbZgQ8sHFs/YLBXAKN928o3NbMdcxRTsVuhbT/VZjGoqE/OWpwA5bcFlX20mruiK44ZOwOXoe/KdyfzmoyCu1EoWNJs0l9/h/Pzvt4/WmMhPiq3RUgDvntrWpDpoddMCS7zDp/ds6DOGsilb9TDfRJculT8BH1IHoAnAXSLtnK12h7+QG1ifFPRe0kNv86JRP5iLmOyfHgiIZD6dD3xj0Hs7A3TJxdZ5JXtvMSoUeF1XVWJ24UgdZrpFm5VRc/Weh07q5rAWcNSqpSVtqG0zXnb12d9VBnVc//oo8r0OEcTTkZXmhal0mrNH2pLEEkTivy1Un0muHu5tiswg0fhAMfSHlxC2GLDDdNL+couzHheU5YDESxQYq/mULwAQY4ZqXN62kTbwUfHJ/+UGZn5XFujumC+1MkY+DdDyLR4MEXi4NPz1Px7RvM9/6dSc3DeCiiCWfJbAQMZQKRS8pVAv/w7caKwnjrrTY+uH5SiJYFGZv7u635ZaGo8YywRtpZQGDrCJJ0KxLdYCHbRnu+rqtFNrIBTra8IIa3PQIKNwcVKg2OI3RMXq5LRA6hdqPDN2KSD/p1ocf0U/Z34o7vrB7tD6wMraUOmJJqZ2h1rSfFFilJdGgGTjwG6W+de75Bge3G/jFgQZtYbAY53LdNqNb96YUBREg1+A7vRGztjYjw12BjRU4tWhdWxR/hhn0CCG0Rt1VSseP+aLErLGVN6jmtKw7pF9pHqB35LWhc3aA7jH3UJCCXmfkzkPKqYyQdsGE1X1mkRnfk5aZfx
 HlJ3ufFO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] rust: bug: warn_once! breaks build when CONFIG_GENERIC_BUG is
  disabled
- [Medium] rust: bug: test_warn_once() always fails with
  suppressed_count =3D=3D 2
- [Low] rust: bug: condition-only macro is named warn_once! instead of
  warn_on_once!
--

commit a4018fab2b94d6f23a5439e460aa5e9ca9e0714c
Author: Ivan Tverdokhleb <mbkchelofficialdev@gmail.com>

rust: bug: add warn_once! macro

This commit adds a warn_once! macro that sets BUGFLAG_ONCE when reporting a
warning, adds a KUnit test for it, and uses it in VmaRef::zap_vma_range().

> diff --git a/rust/kernel/bug.rs b/rust/kernel/bug.rs
> index 3b40b0bd37b50..a0db5c902ecba 100644
> --- a/rust/kernel/bug.rs
> +++ b/rust/kernel/bug.rs
> @@ -156,6 +156,27 @@ macro_rules! warn_on {
>      }};
>  }
> =20
> +/// Report a warning on the first time `cond` is true and return the con=
dition's evaluation result.
> +#[macro_export]
> +macro_rules! warn_once {
> +    ($cond:expr) =3D> {{

[Severity: Low]
Should this macro be named warn_on_once! rather than warn_once!?  In C,
WARN_ON(cond) and WARN_ON_ONCE(cond) take only a condition, whereas
WARN(cond, fmt, ...) and WARN_ONCE(cond, fmt, ...) take a format string.
Since the existing condition-only macro in this file is warn_on!, naming
this warn_on_once! would stay consistent and leave warn_once! available for
formatted warnings.

> +        let cond =3D $cond;
> +
> +        #[cfg(CONFIG_DEBUG_BUGVERBOSE_DETAILED)]
> +        const COND_STR: &str =3D concat!("[", stringify!($cond), "] ", f=
ile!());
> +        #[cfg(not(CONFIG_DEBUG_BUGVERBOSE_DETAILED))]
> +        const COND_STR: &str =3D file!();
> +
> +        if cond {
> +            const WARN_ON_FLAGS: u32 =3D $crate::bug::bugflag_taint($cra=
te::bindings::TAINT_WARN)
> +                | $crate::bindings::BUGFLAG_ONCE;

[Severity: Medium]
Does referencing $crate::bindings::BUGFLAG_ONCE unconditionally here break
the build when CONFIG_GENERIC_BUG is disabled, such as on CONFIG_UML=3Dy or
CONFIG_BUG=3Dn?

In include/asm-generic/bug.h, BUGFLAG_ONCE is only defined under
#ifdef CONFIG_GENERIC_BUG, so bindgen does not generate bindings::BUGFLAG_O=
NCE
when CONFIG_GENERIC_BUG is not set, and VmaRef::zap_vma_range() expands
warn_once! unconditionally in the kernel crate.

> +
> +            $crate::warn_flags!(COND_STR, WARN_ON_FLAGS);
> +        }
> +        cond
> +    }};
> +}
> +
>  #[cfg(CONFIG_RUST_BUG_KUNIT_TEST)]
>  #[macros::kunit_tests(rust_kernel_bug)]
>  mod tests {
> @@ -184,4 +205,29 @@ fn test_warn_on() {
> =20
>          assert_eq!(suppressed_count, 1);
>      }
> +
> +    #[test]
> +    fn test_warn_once() {
> +        // SAFETY: `kunit_get_current_test()` is always safe to call (it=
 has
> +        // fallbacks for when no KUnit test is running).
> +        let test =3D unsafe { bindings::kunit_get_current_test() };
> +
> +        // SAFETY: This function runs only as a KUnit test case, so `tes=
t` is a
> +        // valid pointer to the running test.
> +        let handle =3D unsafe { bindings::kunit_start_suppress_warning(t=
est) };
> +
> +        for _ in 0..2 {
> +            assert!(warn_once!(true));
> +        }
> +
> +        // SAFETY: `kunit_suppressed_warning_count()` accepts any value =
returned by
> +        // `kunit_start_suppress_warning()`.
> +        let suppressed_count =3D unsafe { bindings::kunit_suppressed_war=
ning_count(handle) };
> +
> +        // SAFETY: `test` is valid as above. `kunit_end_suppress_warning=
()` accepts any
> +        // value returned by `kunit_start_suppress_warning()`.
> +        unsafe { bindings::kunit_end_suppress_warning(test, handle) };
> +
> +        assert_eq!(suppressed_count, 1);
> +    }
>  }

[Severity: Medium]
Does test_warn_once() always fail with suppressed_count =3D=3D 2?

On CONFIG_GENERIC_BUG architectures, __report_bug() checks KUnit warning
suppression and returns before checking BUGFLAG_ONCE or setting
BUGFLAG_DONE:

lib/bug.c:__report_bug() {
	...
	/*
	 * Before the once logic so suppressed warnings do not consume
	 * the single-fire budget of WARN_ON_ONCE().
	 */
	if (warning && kunit_is_suppressed_warning(true))
		return BUG_TRAP_TYPE_WARN;

	disable_trace_on_warning();

	if (warning && once) {
		if (done)
			return BUG_TRAP_TYPE_WARN;

		/*
		 * Since this is the only store, concurrency is not an issue.
		 */
		bug->flags |=3D BUGFLAG_DONE;
	}
	...
}

And on CONFIG_ARM, CONFIG_LOONGARCH and CONFIG_UML, warn_flags! ignores
$flags and warns on every call.  In both cases, both loop iterations
increment the suppressed warning counter, so assert_eq!(suppressed_count, 1)
fails.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124132707.1017=
69-1-mbkchelofficialdev@gmail.com?part=3D1

